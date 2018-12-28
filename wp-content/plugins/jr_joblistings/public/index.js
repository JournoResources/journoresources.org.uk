import "./css/main.css";
import { Elm } from "./elm/src/Main.elm";

const container = document.getElementById("jr-joblistings-app");
if (container) {
  const app = Elm.Main.init({
    node: container,
    flags: {
      host: process.env.PUBLIC_URL
    }
  });

  app.ports.updateFormattedHTML.subscribe(() => {
    requestAnimationFrame(updateFormattedHTML);
  });
}

const updateFormattedHTML = () => {
  const htmlNodes = document.querySelectorAll("[data-jr_joblisting_html]");
  htmlNodes.forEach(node => {
    node.innerHTML = node.dataset["jr_joblisting_html"];
  });
};
