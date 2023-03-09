import mongoose from "mongoose";

const alunoSchema = new mongoose.Schema(
  {
    id: {type: String},
    nome: {
      type: String,
      required: [true, "O nome é obrigatório"]
    },
    matricula: {
      type: String,
      required: [true, "A matrícula é obrigatória"]
    }
  },
  {
    versionKey: false
  }
);

const alunos = mongoose.model("alunos", alunoSchema);

export default alunos;