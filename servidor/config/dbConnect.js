import mongoose from "mongoose";

mongoose.connect(process.env.STRING_CONEXAO_DB, {tlsCAFile: "rds-combined-ca-bundle.pem"});

let db = mongoose.connection;

export default db;