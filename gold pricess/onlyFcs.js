const WebSocket = require("ws");
const io = require("socket.io-client");

// ================= CONFIG =================
const API_KEY = "API_KEY";
const WS_PORT = 3294;

// GOLD + SILVER ONLY
const SYMBOLS = {
  1984: "XAUUSD", // GOLD
  1985: "XAGUSD"  // SILVER
};

const FCS_URL = "wss://fcsapi.com";

// =========================================

// Local WebSocket Server
const wss = new WebSocket.Server({ port: WS_PORT });

// Store latest prices
const prices = {};

// Connect to FCS
const fcsSocket = io.connect(FCS_URL, {
  transports: ["websocket"],
  path: "/v3/",
});

fcsSocket.on("connect", () => {
  console.log("✅ Connected to FCS");

  fcsSocket.emit("heartbeat", API_KEY);
  fcsSocket.emit("real_time_join", Object.keys(SYMBOLS).join(","));
});

// Receive FCS data
fcsSocket.on("data_received", (data) => {
  const id = Number(data.id);
  if (!SYMBOLS[id]) return;

  prices[id] = {
    symbol: SYMBOLS[id],
    bid: Number(data.b),
    ask: Number(data.a),
    high: Number(data.h),
    low: Number(data.l),
    time: data.t
  };
console.log(prices);
  broadcast();
});

fcsSocket.on("disconnect", () => {
  console.log("❌ FCS disconnected, reconnecting...");
  setTimeout(() => process.exit(1), 3000);
});

// Broadcast to clients
function broadcast() {
  const payload = {
    type: "prices",
    prices: Object.values(prices)
  };

  wss.clients.forEach(client => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(JSON.stringify(payload));
    }
  });
}

// Client connection
wss.on("connection", (ws) => {
  ws.send(JSON.stringify({
    type: "prices",
    prices: Object.values(prices)
  }));
});

setInterval(() => {
  fcsSocket.emit("heartbeat", API_KEY);
}, 3600000);

console.log(`🚀 WebSocket running on port ${WS_PORT}`);
