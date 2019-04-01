const recipeFilter = document.getElementById('recipe-filter');

if (recipeFilter) {
  recipeFilter.addEventListener('input', () => {
    const filter = recipeFilter.value.toLowerCase();
    const recipes = Array.prototype.slice.call(document.querySelectorAll('td.recipe'), 0);
    const recipeLetters = Array.prototype.slice.call(document.querySelectorAll('th.recipe-letter'), 0);

    recipes.forEach(el => {
      if (filter.length == 0 || el.innerHTML.toLowerCase().includes(filter)) {
        el.style.display = 'block';
      } else {
        el.style.display = 'none';
      }
    });

    recipeLetters.forEach(el => {
      if (filter.length == 0) {
        el.style.display = 'block';
      } else {
        el.style.display = 'none';
      }
    });
  });
}
