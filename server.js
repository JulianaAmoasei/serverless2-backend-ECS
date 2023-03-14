import "dotenv/config";
import app from "./servidor/app.js";

const port = process.env.PORT || 80;


app.listen(port, () => {
  console.log(`Servidor escutando em http://localhost:${port}`);
});