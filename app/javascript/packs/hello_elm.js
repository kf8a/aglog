// Run this example by adding <%= javascript_pack_tag "hello_elm" %> to the
// head of your layout file, like app/views/layouts/application.html.erb.
// It will render "Hello Elm!" within the page.

import {
  Elm
} from '../Main'

function loadMetaTagData(name) {
  const element = document.querySelectorAll(`meta[name=${name}]`)[0];

  if (typeof element !== "undefined") {
    return element.getAttribute("content");
  } else {
    return null;
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const containerId = "obsform";
  const name = loadMetaTagData("csrf-token");
  const target = document.getElementById(containerId);
  const obsid = target.getAttribute("data-obsid");

  document.body.appendChild(target)
  Elm.Main.init({
    node: target,
    flags: {id: parseInt(obsid), csrf: name}
  })
})
