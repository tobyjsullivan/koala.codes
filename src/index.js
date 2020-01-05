import logo from './image/koala001.jpg';

function main() {
  load_logo();
}

function load_logo() {
  const $logo = document.getElementById('logo');
  $logo.src = logo;
}

main();
