/* 
  npm install ws dotenv
  Set your API key in .env as FCS_API_KEY
*/

const WebSocket = require("ws");
const FCSClient = require("./fcs-client-lib");
require("dotenv").config();

const LOCAL_WS_PORT = process.env.PORT || 3294;
// Include all possible XAUUSD symbols you are subscribing to
const SYMBOLS = ["XAUUSD", "ONA:XAUUSD", "SFO:XAUUSD"];

// ---------------- Local WebSocket server ----------------
const wss = new WebSocket.Server({ port: LOCAL_WS_PORT });
console.log(`🚀 Local WebSocket server running on port ${LOCAL_WS_PORT}`);

let latestPrices = {};

// Broadcast function
function broadcast() {
    const payload = { type: "prices", prices: Object.values(latestPrices) };
    wss.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(JSON.stringify(payload));
        }
    });
}

// Send latest price on new connection
wss.on("connection", ws => {
    if (Object.keys(latestPrices).length > 0) {
        ws.send(JSON.stringify({ type: "prices", prices: Object.values(latestPrices) }));
    }
});

// ---------------- FCS WebSocket client ----------------
const client = new FCSClient("fcs_socket_demo", "wss://ws-v4.fcsapi.com/ws");

client.connect()
    .then(() => console.log("✅ Connected to FCS WebSocket"))
    .catch(err => console.error("❌ Connection failed:", err));

client.onconnected = () => {
    console.log("🔑 Authenticated and ready");
    
    const symbols = [
        { symbol: "BINANCE:BTCUSDT", timeframe: "60" },
        { symbol: "BINANCE:ETHUSDT", timeframe: "60" },
        { symbol: "FLC:EURUSD", timeframe: "15" },
        { symbol: "ONA:XAUUSD", timeframe: "15" },
        { symbol: "SFO:XAUUSD", timeframe: "15" },
        { symbol: "NASDAQ:AAPL", timeframe: "1D" }
    ];

    // Subscribe correctly
    symbols.forEach(sym => client.join(sym.symbol, sym.timeframe));
};

client.onmessage = (data) => {
    // Only handle price data for gold symbols
    if (data.type === "price" && SYMBOLS.includes(data.symbol)) {
        const priceData = {
            symbol: data.symbol,
            bid: parseFloat(data.prices.b),
            ask: parseFloat(data.prices.a),
            high: parseFloat(data.prices.h),
            low: parseFloat(data.prices.l),
            close: parseFloat(data.prices.c),
            time: data.prices.t
        };

        latestPrices[data.symbol] = priceData;
        console.log("Gold Price Updated:", priceData);

        broadcast();
    }
};

// Optional: handle disconnects
client.ondisconnected = () => {
    console.log("❌ FCS disconnected, retrying in 15s...");
    setTimeout(() => client.connect(), 15000);
};

// Keep process alive
process.on("SIGINT", () => {
    console.log("Shutting down...");
    client.disconnect();
    process.exit(0);
});
