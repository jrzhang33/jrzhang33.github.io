(() => {
  'use strict';

  document.documentElement.classList.add('js-enabled');

  const filterButtons = [...document.querySelectorAll('[data-publication-filter]')];
  const publications = [...document.querySelectorAll('.publication[data-year]')];
  const menuToggle = document.querySelector('.menu-toggle');
  const navLinks = document.querySelector('.nav-links');

  function applyPublicationFilter(filter) {
    publications.forEach((publication) => {
      const year = Number(publication.dataset.year);
      const matchesFilter = filter === 'all'
        || (filter === 'earlier' ? year <= 2024 : publication.dataset.year === filter);

      publication.hidden = !matchesFilter;
    });
  }

  filterButtons.forEach((button) => {
    button.addEventListener('click', () => {
      filterButtons.forEach((item) => {
        item.setAttribute('aria-pressed', String(item === button));
      });

      applyPublicationFilter(button.dataset.publicationFilter);
    });
  });

  function setMenuOpen(isOpen) {
    if (!menuToggle || !navLinks) {
      return;
    }

    menuToggle.setAttribute('aria-expanded', String(isOpen));
    navLinks.dataset.open = String(isOpen);
  }

  if (menuToggle && navLinks) {
    menuToggle.addEventListener('click', () => {
      setMenuOpen(menuToggle.getAttribute('aria-expanded') !== 'true');
    });

    navLinks.addEventListener('click', (event) => {
      if (event.target.closest('a')) {
        setMenuOpen(false);
      }
    });

    document.addEventListener('keydown', (event) => {
      if (event.key === 'Escape') {
        setMenuOpen(false);
      }
    });
  }
})();
