import { createClient } from 'npm:@supabase/supabase-js@2';
import { JWT } from 'npm:google-auth-library@9';
import { config } from "https://deno.land/x/dotenv@v3.2.2/mod.ts";

const env = config();

const supabaseUrl = env.SUPABASE_URL;
const supabaseKey = env.SUPABASE_ANON_KEY;

interface Application {
  centerName: string,
  solicitor: string,

}

interface WebhookPayload {
  type: 'INSERT',
  table: string,
  record: Application,
  schema: 'public',

}

const supabase = createClient(
  supabaseUrl,
  supabaseKey

)

Deno.serve(async (req) => {
  const payload: WebhookPayload = await req.json();

  const {data} = await supabase.from('users').select('fcm_token').eq('id', payload.record.solicitor).single();

  const fcm_token = data!.fcm_token as string;

  const {default: serviceAccount} = await import('../service-account.json', {
    with: {type: 'json'}
  });


  const accessToken = await getAccessToken({client_email: serviceAccount.client_email, private_key: serviceAccount.private_key});

  const res = await fetch(`https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`, 
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${accessToken}`
      },
      body: JSON.stringify({
        message:{
          token: fcm_token,
          notification: {
            title: 'Nueva solicitud disponible',
            body: `${payload.record.centerName} ha enviado una tu solicitud para ser un centro de acopio.`,
          },
        },
      })
    })

  const resData = await res.json();

  if(res.status < 200 || res.status > 300){
    throw(resData);
  }

  return new Response(JSON.stringify(resData), {
    headers: { 'Content-Type': 'application/json' }
  })
})


const getAccessToken = ({
  client_email,
  private_key,
}:{
  client_email: string,
  private_key: string,
}
): Promise<string> => {
  return new Promise((resolve, reject) => {
    const jwtClient = new JWT({
      email: client_email,
      key: private_key,
      scopes: ['https://www.googleapis.com/auth/firebase.messaging'],

    })
    jwtClient.authorize((err, tokens) =>{
      if(err){
        reject(err);
        return;
      }
      
      resolve(tokens!.access_token!);
      
    })

  })

}