import "./css/main.scss";
import { Elm } from "./elm/src/Main.elm";

const container = document.getElementById("jr-salaries-app");
if (container) {
  const app = Elm.Main.init({
    node: container,
    flags: {
      host: process.env.PUBLIC_URL,
      viewType: container.dataset.view
    }
  });
}
