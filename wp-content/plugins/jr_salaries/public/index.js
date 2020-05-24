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

  window.recaptchaOnloadCallback = () => {
    grecaptcha.render(
      document.querySelector('#jr-salaries-form .g-recaptcha'),
      {
        sitekey: "6LcoY_sUAAAAAHUNhCO0VriapB1OAQvAnbfWGN4O",
        callback: token => {
          app.ports.recaptchaSubmit.send(token)
        }
      }
    );
  }
}
