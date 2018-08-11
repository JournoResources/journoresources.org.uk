import '../css/main.css';
import { Main } from '../elm/src/Main.elm';

var container = document.getElementById('jr-joblistings');
if (container) Main.embed(container, {
    host: process.env.PUBLIC_URL
});