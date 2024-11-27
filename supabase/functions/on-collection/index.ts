import { createClient } from 'npm:@supabase/supabase-js@2';
import { config } from "https://deno.land/x/dotenv@v3.2.2/mod.ts";

const env = config();

const supabaseUrl = env.SUPABASE_URL;
const supabaseKey = env.SUPABASE_ANON_KEY;

interface Collection {
  centerRequesting: number,

}

interface WebhookPayload {
  type: 'DELETE',
  table: string,
  old_record: Collection,
  schema: 'public',

}

const supabase = createClient(
  supabaseUrl,
  supabaseKey
)

Deno.serve(async (req) => {
  const payload: WebhookPayload = await req.json();

  const updateRes = await supabase
    .from('centers')
    .update({ currentCapacity: 0})
    .eq('id', payload.old_record.centerRequesting)
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
