import postgres from "postgres";

const sql = postgres();

async function getQuote() {
  const quote = await sql`
    select text || ' -- ' || author as quote
    from quote
    order by random()
    limit 1
  `;
  return quote[0].quote;
}

async function main() {
  console.log(`Random Quote: ${await getQuote()}`);
}

try {
  await main();
} finally {
  await sql.end();
}
