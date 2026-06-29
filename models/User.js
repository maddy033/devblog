const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true },
  password: { type: String, required: true },
  role: {
    type: String,
    enum: ["admin", "author", "reader"],
    default: "reader",
  },
});

// Create User model
const User = mongoose.model("User", userSchema);
module.exports = User;