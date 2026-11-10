(() => {
  const header = document.querySelector('[data-header]');
  const toggle = document.querySelector('[data-nav-toggle]');
  const newHere = document.querySelector('[data-new-here]');
  const onScroll = () => {
    if (header) header.classList.toggle('is-scrolled', window.scrollY > 24);
    if (newHere) {
      const nearEnd = window.innerHeight + window.scrollY > document.documentElement.scrollHeight - 420;
      newHere.classList.toggle('is-shown', window.scrollY > 640 && !nearEnd);
    }
  };
  onScroll();
  window.addEventListener('scroll', onScroll, { passive: true });

  if (toggle) {
    const setOpen = (open) => {
      document.body.classList.toggle('nav-open', open);
      toggle.setAttribute('aria-expanded', String(open));
    };
    toggle.addEventListener('click', () => setOpen(!document.body.classList.contains('nav-open')));
    document.addEventListener('keydown', (e) => { if (e.key === 'Escape') setOpen(false); });
    document.querySelectorAll('[data-nav] a').forEach((a) => a.addEventListener('click', () => setOpen(false)));
  }

  document.querySelectorAll('[data-map-load]').forEach((btn) => btn.addEventListener('click', () => {
    const box = btn.closest('[data-map]');
    const f = document.createElement('iframe');
    f.src = box.dataset.map; f.title = 'Map to Westside Community Church';
    f.referrerPolicy = 'no-referrer-when-downgrade';
    box.replaceChildren(f);
  }));

  if ('IntersectionObserver' in window && !matchMedia('(prefers-reduced-motion: reduce)').matches) {
    const targets = document.querySelectorAll('.section .wrap > *, .feature, .leader, .path, .day, .event');
    const io = new IntersectionObserver((entries) => {
      entries.forEach((en) => { if (en.isIntersecting) { en.target.classList.add('is-in'); io.unobserve(en.target); } });
    }, { rootMargin: '0px 0px -8% 0px' });
    targets.forEach((el) => {
      if (el.getBoundingClientRect().top > window.innerHeight) { el.classList.add('reveal'); io.observe(el); }
    });
  }
})();
