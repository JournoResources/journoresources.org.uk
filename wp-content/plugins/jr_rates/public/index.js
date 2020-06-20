import "./css/main.scss";
import { Elm } from "./elm/src/Main.elm";

const container = document.getElementById("jr-rates-app");
if (container) {
  const app = Elm.Main.init({
    node: container,
    flags: {
      host: process.env.PUBLIC_URL,
      viewType: container.dataset.view
    }
  });

  window.recaptchaOnloadCallback = () => {
    const div = document.querySelector('#jr-rates-form .g-recaptcha')
    if (div) {
      grecaptcha.render(
        div,
        {
          sitekey: "6LcoY_sUAAAAAHUNhCO0VriapB1OAQvAnbfWGN4O",
          callback: token => {
            app.ports.recaptchaSubmit.send(token)
          }
        }
      );
    }
  }

  app.ports.recaptchaRefresh.subscribe(() => {
    recaptchaOnloadCallback()
  })
}
