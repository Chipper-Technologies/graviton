// Remove loading screen when Flutter is ready
window.addEventListener('flutter-first-frame', function() {
  const loading = document.getElementById('loading');
  if (loading) {
    loading.style.opacity = '0';
    loading.style.transition = 'opacity 0.5s ease-out';
    setTimeout(() => loading.remove(), 500);
  }
});
