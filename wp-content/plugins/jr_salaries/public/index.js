import "./css/main.scss";
import { Elm } from "./elm/src/Main.elm";

const container = document.getElementById("jr-salaries-app");
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
  const htmlNodes = document.querySelectorAll("[data-jr_salary_html]");
  htmlNodes.forEach(node => {
    node.innerHTML = node.dataset["jr_salary_html"];
  });
};
