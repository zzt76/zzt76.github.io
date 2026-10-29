(() => {
  const select = document.querySelector('#theme-select');
  // The theme UI is omitted while the site is light-only.
  if (select) {
    const themes = ['light', 'dark'];
    let savedTheme;
    try { savedTheme = localStorage.getItem('site-theme'); } catch (error) { /* Storage may be disabled. */ }
    select.value = themes.includes(savedTheme) ? savedTheme : 'system';
    select.closest('label').hidden = false;

    const applyTheme = (theme) => {
      if (themes.includes(theme)) document.documentElement.dataset.theme = theme;
      else delete document.documentElement.dataset.theme;
    };
    select.addEventListener('change', () => {
      applyTheme(select.value);
      try {
        if (select.value === 'system') localStorage.removeItem('site-theme');
        else localStorage.setItem('site-theme', select.value);
      } catch (error) { /* The selection still works for this page. */ }
    });
    // Auto mode follows OS changes through CSS; keep manual choices in sync across tabs.
    window.addEventListener('storage', (event) => {
      if (event.key !== 'site-theme' && event.key !== null) return;
      const theme = themes.includes(event.newValue) ? event.newValue : 'system';
      select.value = theme;
      applyTheme(theme);
    });
  }

  const dialog = document.querySelector('.lightbox');
  const dialogImage = dialog.querySelector('img');
  document.querySelectorAll('[data-lightbox]').forEach((button) => {
    button.addEventListener('click', () => {
      const image = button.querySelector('img');
      dialogImage.src = image.currentSrc || image.src;
      dialogImage.alt = image.alt;
      dialog.querySelector('.lightbox-caption').textContent = image.alt;
      dialog.showModal();
      document.body.classList.add('lightbox-open');
    });
  });
  dialog.querySelector('button').addEventListener('click', () => dialog.close());
  dialog.addEventListener('click', (event) => {
    if (event.target !== dialog) return;
    const bounds = dialog.getBoundingClientRect();
    if (event.clientX < bounds.left || event.clientX > bounds.right || event.clientY < bounds.top || event.clientY > bounds.bottom) dialog.close();
  });
  dialog.addEventListener('close', () => {
    document.body.classList.remove('lightbox-open');
    dialogImage.removeAttribute('src');
  });
})();
