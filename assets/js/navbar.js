document.addEventListener('DOMContentLoaded', () => {
  const navbarToggles = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  if (navbarToggles.length > 0) {
    navbarToggles.forEach(el => {
      el.addEventListener('click', () => {
        const targetId = el.dataset.target;
        const target = document.getElementById(targetId);

        el.classList.toggle('is-active');
        target.classList.toggle('is-active');
      });
    });
  }
});
