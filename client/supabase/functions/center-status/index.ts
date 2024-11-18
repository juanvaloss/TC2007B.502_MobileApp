import { createClient } from 'npm:@supabase/supabase-js@2';
import { JWT } from 'npm:google-auth-library@9';
import { config } from "https://deno.land/x/dotenv@v3.2.2/mod.ts";

const env = config();

const supabaseUrl = env.SUPABASE_URL;
const supabaseKey = env.SUPABASE_ANON_KEY;

interface CenterInfo {
  approvedBy: string,
  centerName: string,
  currentCapacity: string,
  totalCapacity: string

}

interface WebhookPayload {
  type: 'UPDATE',
  table: string,
  record: CenterInfo,
  schema: 'public',

}

const supabase = createClient(
  supabaseUrl,
  supabaseKey

)

Deno.serve(async (req) => {
  const payload: WebhookPayload = await req.json();

  //We want to send the notification to the admin that approved the center
  const {data} = await supabase.from('admins').select('fcm_token').eq('id', payload.record.approvedBy).single();

  const fcm_token = data!.fcm_token as string;

  const {default: serviceAccount} = await import('../service-account.json', {
    with: {type: 'json'}
  });


  const accessToken = await getAccessToken({client_email: serviceAccount.client_email, private_key: serviceAccount.private_key});

  //Calculate the percentage of the center's capacity before sending the notification
  const percentage = Math.floor(
    (parseInt(payload.record.currentCapacity) / parseInt(payload.record.totalCapacity)) * 100
  );

  //We only want to send the notification if the center is above 85% capacity
  if (percentage < 85) {
    return new Response('Notification not sent: capacity below 80%', { status: 204 });
  }

  const res = await fetch(`https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`, 
    {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${accessToken}`
      },
      body: JSON.stringify({
        message:{
          //This is what we would change to send the notification to different admins, we need their fcm_token though
          token: fcm_token,
          notification: {
            title: `${payload.record.centerName} casi lleno!!!`,
            body: `El centro ha alcanzado el ${percentage}% de su capacidad total. Anticipa la recolección.`,
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