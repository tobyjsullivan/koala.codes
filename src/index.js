import logo from './image/koala001.jpg';

const TITLE = 'koala.codes';
const TYPE_DELAY_MS = 20;

function main() {
  setTimeout(emulate_typed_title, TYPE_DELAY_MS);
  load_logo();
}

function load_logo() {
  const $logo = document.getElementById('logo');
  $logo.src = logo;
}

function emulate_typed_title() {
  const $title = document.getElementById('title');
  const substringLen = $title.innerHTML.length + 1;

  if (substringLen > TITLE.length) {
    return;
  }

  const substring = TITLE.substring(0, substringLen);
  $title.innerHTML = substring;

  setTimeout(emulate_typed_title, TYPE_DELAY_MS);
}

main();
