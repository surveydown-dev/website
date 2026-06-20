// ---- Lab Logo (navbar far-right) ----
// Inject directly into .navbar-container so `order: 9999` (in CSS) pushes it
// past the search/toggle group, matching how quarto.org places its Posit logo.
(function () {
  function injectLabLogo() {
    var container = document.querySelector('nav.navbar .navbar-container');
    if (!container || container.querySelector('.navbar-lab-link')) return;
    var link = document.createElement('a');
    link.className = 'navbar-lab-link';
    link.href = 'https://www.jhelvy.com/lab';
    link.target = '_blank';
    link.rel = 'noopener';
    link.setAttribute('aria-label', 'Helveston Lab');
    var img = document.createElement('img');
    img.src = '/images/logo-lab.png';
    img.alt = 'Helveston Lab';
    link.appendChild(img);
    container.appendChild(link);
  }
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', injectLabLogo);
  } else {
    injectLabLogo();
  }
})();
