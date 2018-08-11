import '../css/main.css';
import { Main } from '../elm/src/Main.elm';
// import registerServiceWorker from './registerServiceWorker';

var container = document.getElementById('elm');
if (container) Main.embed(container);

// registerServiceWorker();
