import "./css/main.css";
import { Elm } from "./elm/src/Main.elm";

var container = document.getElementById("jr-joblistings");
if (container)
  Elm.Main.init({
    node: container,
    flags: {
      host: process.env.PUBLIC_URL
    }
  });
