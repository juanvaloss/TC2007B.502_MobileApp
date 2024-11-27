import { createClient } from 'npm:@supabase/supabase-js@2';
import { config } from "https://deno.land/x/dotenv@v3.2.2/mod.ts";

const env = config();

const supabaseUrl = env.SUPABASE_URL;
const supabaseKey = env.SUPABASE_ANON_KEY;

interface Donation {
  receivedIn: string,
  quantity: number,

}

interface WebhookPayload {
  type: 'INSERT',
  table: string,
  record: Donation,
  schema: 'public',

}

const supabase = createClient(
  supabaseUrl,
  supabaseKey
)

Deno.serve(async (req) => {
  const payload: WebhookPayload = await req.json();

  const { data, error } = await supabase
    .from('centers')
    .select('currentCapacity, totalCapacity')
    .eq('id', payload.record.receivedIn)
    .single();

  if (error || data == null) {
    return new Response('Center not found', { status: 404 });
  }

  const currentCapacity = data.currentCapacity as number;
  const totalCapacity = data.totalCapacity as number;
  console.log(currentCapacity, totalCapacity);

  if(currentCapacity + payload.record.quantity > totalCapacity){
    return new Response('Not enough capacity', { status: 400 });
  }

  const updateRes = await supabase
    .from('centers')
    .update({ currentCapacity: currentCapacity + payload.record.quantity })
    .eq('id', payload.record.receivedIn)
    .select('currentCapacity')
    .single();

  if (updateRes.error) {
    return new Response(
      JSON.stringify({ error: updateRes.error.message || 'Unknown error occurred' }),
      {
        status: 500,
        headers: { 'Content-Type': 'application/json' },
      }
    );
  }

  console.log('Response data:', updateRes);

  return new Response(JSON.stringify({ message: 'Capacity updated successfully', newCapacity: updateRes.data.currentCapacity }),
  {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  })

})
