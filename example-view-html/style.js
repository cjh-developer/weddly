/* ════════════════════════════════════════
   style.js  –  Weddly 통합 스크립트
════════════════════════════════════════ */

// ── 공통 유틸 ──
function setMsg(id, text, type) {
  const el = document.getElementById(id);
  if (!el) return;
  el.textContent = text;
  el.className = 'field-msg ' + (type || '');
}

function setBorder(wrapperId, type) {
  const el = document.getElementById(wrapperId);
  if (!el) return;
  el.classList.remove('error-border', 'success-border');
  if (type) el.classList.add(type + '-border');
}

const EYE_OPEN   = `<path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>`;
const EYE_CLOSED = `<path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94"/><path d="M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><line x1="1" y1="1" x2="23" y2="23"/>`;

function applyPhoneFormat(el) {
  el.addEventListener('input', function () {
    let v = this.value.replace(/\D/g, '');
    if (v.length <= 3)      this.value = v;
    else if (v.length <= 7) this.value = v.slice(0,3) + '-' + v.slice(3);
    else                    this.value = v.slice(0,3) + '-' + v.slice(3,7) + '-' + v.slice(7,11);
  });
}

// ── 공통: 비밀번호 보기/숨기기 ──
document.querySelectorAll('.toggle-pw').forEach(btn => {
  btn.addEventListener('click', () => {
    const targetId = btn.dataset.target;
    const input    = targetId ? document.getElementById(targetId) : document.getElementById('password');
    const icon     = btn.querySelector('.eye-icon') || document.getElementById('eyeIcon');
    if (!input || !icon) return;
    const isHidden = input.type === 'password';
    input.type     = isHidden ? 'text' : 'password';
    icon.innerHTML = isHidden ? EYE_CLOSED : EYE_OPEN;
  });
});

// ── 공통: 전화번호 자동 하이픈 ──
['phone', 'resetPhone'].forEach(id => {
  const el = document.getElementById(id);
  if (el) applyPhoneFormat(el);
});

// ════════════════════════════════════════
// 로그인 페이지
// ════════════════════════════════════════
if (document.getElementById('loginBtn')) {
  const loginBtn = document.getElementById('loginBtn');

  loginBtn.addEventListener('click', () => {
    const id = document.getElementById('email').value.trim();
    const pw = document.getElementById('password').value;
    if (!id) { alert('아이디를 입력해주세요.'); document.getElementById('email').focus(); return; }
    if (!pw) { alert('비밀번호를 입력해주세요.'); document.getElementById('password').focus(); return; }
    console.log('로그인 요청:', { id, remember: document.getElementById('remember').checked });
    alert('로그인 API 연동 예정');
  });

  [document.getElementById('email'), document.getElementById('password')].forEach(el => {
    el.addEventListener('keydown', e => { if (e.key === 'Enter') loginBtn.click(); });
  });

  document.querySelector('.btn-google').addEventListener('click', () => { console.log('Google OAuth 연동 예정'); alert('Google 로그인 연동 예정'); });
  document.querySelector('.btn-kakao').addEventListener('click',  () => { console.log('Kakao OAuth 연동 예정');  alert('Kakao 로그인 연동 예정');  });
  document.querySelector('.btn-naver').addEventListener('click',  () => { console.log('Naver OAuth 연동 예정');  alert('Naver 로그인 연동 예정');  });
}

// ════════════════════════════════════════
// 회원가입 페이지
// ════════════════════════════════════════
if (document.getElementById('signupForm')) {

  // 모달
  function openModal(id) { document.getElementById(id).classList.add('active'); document.body.style.overflow = 'hidden'; }
  function closeModal(id) { document.getElementById(id).classList.remove('active'); document.body.style.overflow = ''; }

  document.querySelectorAll('.terms-link[data-modal]').forEach(link => {
    link.addEventListener('click', e => { e.preventDefault(); openModal(link.dataset.modal); });
  });

  document.querySelectorAll('[data-close]').forEach(btn => {
    btn.addEventListener('click', () => {
      if (btn.dataset.agree) {
        const cb = document.getElementById(btn.dataset.agree);
        if (cb) { cb.checked = true; cb.dispatchEvent(new Event('change')); }
      }
      closeModal(btn.dataset.close);
    });
  });

  document.querySelectorAll('.modal-overlay').forEach(overlay => {
    overlay.addEventListener('click', e => { if (e.target === overlay) closeModal(overlay.id); });
  });

  document.addEventListener('keydown', e => {
    if (e.key === 'Escape') document.querySelectorAll('.modal-overlay.active').forEach(m => closeModal(m.id));
  });

  // 비밀번호 강도
  const strengthFill  = document.getElementById('strengthFill');
  const strengthLabel = document.getElementById('strengthLabel');

  function calcStrength(pw) {
    let score = 0;
    if (pw.length >= 8)           score++;
    if (pw.length >= 12)          score++;
    if (/[A-Z]/.test(pw))         score++;
    if (/[a-z]/.test(pw))         score++;
    if (/[0-9]/.test(pw))         score++;
    if (/[^A-Za-z0-9]/.test(pw))  score++;
    return score;
  }

  document.getElementById('password').addEventListener('input', function () {
    const pw    = this.value;
    const score = pw ? calcStrength(pw) : 0;
    const pct   = Math.min(Math.round((score / 6) * 100), 100);
    let color, label;
    if (!pw)           { color = '#eee';    label = '';    }
    else if (score<=2) { color = '#f44336'; label = '약함'; }
    else if (score<=4) { color = '#FF9800'; label = '보통'; }
    else               { color = '#4caf50'; label = '강함'; }
    strengthFill.style.width      = pct + '%';
    strengthFill.style.background = color;
    strengthLabel.textContent     = label;
    strengthLabel.style.color     = color;
    validatePasswordConfirm();
  });

  function validatePasswordConfirm() {
    const pw      = document.getElementById('password').value;
    const confirm = document.getElementById('passwordConfirm').value;
    if (!confirm) return;
    if (pw === confirm) { setMsg('passwordConfirmMsg', '비밀번호가 일치합니다.', 'success'); setBorder('passwordConfirmWrapper', 'success'); }
    else                { setMsg('passwordConfirmMsg', '비밀번호가 일치하지 않습니다.', 'error'); setBorder('passwordConfirmWrapper', 'error'); }
  }

  document.getElementById('passwordConfirm').addEventListener('input', validatePasswordConfirm);

  // 아이디 중복 확인
  let idChecked = false;

  document.getElementById('userId').addEventListener('input', () => {
    idChecked = false;
    const btn = document.getElementById('checkIdBtn');
    btn.classList.remove('confirmed');
    btn.textContent = '중복확인';
    setMsg('userIdMsg', '', '');
    setBorder('userIdWrapper', '');
  });

  document.getElementById('checkIdBtn').addEventListener('click', () => {
    const id = document.getElementById('userId').value.trim();
    if (!id) { setMsg('userIdMsg', '아이디를 입력해주세요.', 'error'); setBorder('userIdWrapper', 'error'); return; }
    if (!/^[a-z0-9]{4,20}$/.test(id)) { setMsg('userIdMsg', '영문 소문자·숫자 4~20자로 입력해주세요.', 'error'); setBorder('userIdWrapper', 'error'); return; }
    console.log('아이디 중복 확인 요청:', id);
    const takenIds = ['admin', 'test123', 'user01'];
    if (takenIds.includes(id)) {
      setMsg('userIdMsg', '이미 사용 중인 아이디입니다.', 'error'); setBorder('userIdWrapper', 'error'); idChecked = false;
    } else {
      setMsg('userIdMsg', '사용 가능한 아이디입니다.', 'success'); setBorder('userIdWrapper', 'success');
      const btn = document.getElementById('checkIdBtn');
      btn.classList.add('confirmed'); btn.textContent = '\u2713 확인됨'; idChecked = true;
    }
  });

  // 전체 동의
  const agreeAllCheckbox = document.getElementById('agreeAll');
  const agreeItems       = document.querySelectorAll('.agree-item');
  agreeAllCheckbox.addEventListener('change', () => { agreeItems.forEach(cb => { cb.checked = agreeAllCheckbox.checked; }); });
  agreeItems.forEach(cb => { cb.addEventListener('change', () => { agreeAllCheckbox.checked = [...agreeItems].every(c => c.checked); }); });

  // 폼 제출
  document.getElementById('signupForm').addEventListener('submit', e => {
    e.preventDefault();
    let isValid = true;
    const userId   = document.getElementById('userId').value.trim();
    const userName = document.getElementById('userName').value.trim();
    const pw       = document.getElementById('password').value;
    const confirm  = document.getElementById('passwordConfirm').value;
    const email    = document.getElementById('email').value.trim();
    const phone    = document.getElementById('phone').value.trim();
    const role     = document.querySelector('input[name="role"]:checked');

    if (!userId)      { setMsg('userIdMsg', '아이디를 입력해주세요.', 'error'); setBorder('userIdWrapper', 'error'); isValid = false; }
    else if (!idChecked) { setMsg('userIdMsg', '아이디 중복 확인을 해주세요.', 'error'); setBorder('userIdWrapper', 'error'); isValid = false; }

    if (!userName) { setMsg('userNameMsg', '이름을 입력해주세요.', 'error'); setBorder('userNameWrapper', 'error'); isValid = false; }
    else           { setMsg('userNameMsg', '', ''); setBorder('userNameWrapper', 'success'); }

    if (!pw)              { setMsg('passwordMsg', '비밀번호를 입력해주세요.', 'error'); setBorder('passwordWrapper', 'error'); isValid = false; }
    else if (calcStrength(pw) < 3) { setMsg('passwordMsg', '더 강력한 비밀번호를 설정해주세요.', 'error'); setBorder('passwordWrapper', 'error'); isValid = false; }
    else                  { setMsg('passwordMsg', '', ''); setBorder('passwordWrapper', 'success'); }

    if (!confirm)        { setMsg('passwordConfirmMsg', '비밀번호 확인을 입력해주세요.', 'error'); setBorder('passwordConfirmWrapper', 'error'); isValid = false; }
    else if (pw !== confirm) { setMsg('passwordConfirmMsg', '비밀번호가 일치하지 않습니다.', 'error'); setBorder('passwordConfirmWrapper', 'error'); isValid = false; }

    if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) { setMsg('emailMsg', '올바른 이메일 형식을 입력해주세요.', 'error'); setBorder('emailWrapper', 'error'); isValid = false; }
    else { setMsg('emailMsg', '', ''); setBorder('emailWrapper', 'success'); }

    if (!phone || !/^010-\d{4}-\d{4}$/.test(phone)) { setMsg('phoneMsg', '올바른 전화번호를 입력해주세요. (010-0000-0000)', 'error'); setBorder('phoneWrapper', 'error'); isValid = false; }
    else { setMsg('phoneMsg', '', ''); setBorder('phoneWrapper', 'success'); }

    if (!role) { setMsg('roleMsg', '신랑 또는 신부를 선택해주세요.', 'error'); isValid = false; }
    else       { setMsg('roleMsg', '', ''); }

    if (!document.getElementById('agreeService').checked || !document.getElementById('agreePrivacy').checked) {
      alert('필수 약관에 동의해주세요.'); isValid = false;
    }

    if (!isValid) return;

    const payload = { userId, userName, password: pw, email, phone, role: role.value, agreeMarketing: document.getElementById('agreeMarketing').checked };
    console.log('회원가입 요청:', payload);
    alert('회원가입 API 연동 예정\n\n' + JSON.stringify(payload, null, 2));
  });
}

// ════════════════════════════════════════
// 아이디 찾기 페이지
// ════════════════════════════════════════
if (document.getElementById('findIdForm')) {

  document.getElementById('findIdForm').addEventListener('submit', e => {
    e.preventDefault();
    let isValid = true;
    const name  = document.getElementById('findName').value.trim();
    const email = document.getElementById('findEmail').value.trim();

    if (!name) { setMsg('findNameMsg', '이름을 입력해주세요.', 'error'); setBorder('findNameWrapper', 'error'); isValid = false; }
    else       { setMsg('findNameMsg', '', ''); setBorder('findNameWrapper', 'success'); }

    if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) { setMsg('findEmailMsg', '올바른 이메일 형식을 입력해주세요.', 'error'); setBorder('findEmailWrapper', 'error'); isValid = false; }
    else { setMsg('findEmailMsg', '', ''); setBorder('findEmailWrapper', 'success'); }

    if (!isValid) return;

    console.log('아이디 찾기 요청:', { name, email });
    const mockData = { found: true, userId: 'wed***y', createdAt: '2024년 11월 가입' };
    const formEl   = document.getElementById('findIdForm');
    const resultEl = document.getElementById('findResult');
    if (mockData.found) {
      document.getElementById('resultIdText').textContent   = mockData.userId;
      document.getElementById('resultDateText').textContent = mockData.createdAt;
      formEl.style.display = 'none';
      resultEl.classList.add('show');
    } else {
      setMsg('findEmailMsg', '입력하신 정보와 일치하는 아이디가 없어요.', 'error');
      setBorder('findEmailWrapper', 'error');
    }
  });

  const goFindPw = document.getElementById('goFindPw');
  if (goFindPw) {
    goFindPw.addEventListener('click', e => { e.preventDefault(); alert('비밀번호 초기화 페이지 연동 예정'); });
  }
}

// ════════════════════════════════════════
// 비밀번호 초기화 페이지
// ════════════════════════════════════════
if (document.getElementById('resetPwForm')) {

  function maskEmail(email) {
    const [local, domain] = email.split('@');
    const masked = local.length <= 2 ? local[0] + '*'.repeat(local.length - 1) : local.slice(0,2) + '*'.repeat(local.length - 2);
    return masked + '@' + domain;
  }

  document.getElementById('resetPwForm').addEventListener('submit', e => {
    e.preventDefault();
    let isValid = true;
    const userId = document.getElementById('resetUserId').value.trim();
    const email  = document.getElementById('resetEmail').value.trim();
    const phone  = document.getElementById('resetPhone').value.trim();

    if (!userId) { setMsg('resetUserIdMsg', '아이디를 입력해주세요.', 'error'); setBorder('resetUserIdWrapper', 'error'); isValid = false; }
    else         { setMsg('resetUserIdMsg', '', ''); setBorder('resetUserIdWrapper', 'success'); }

    if (!email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) { setMsg('resetEmailMsg', '올바른 이메일 형식을 입력해주세요.', 'error'); setBorder('resetEmailWrapper', 'error'); isValid = false; }
    else { setMsg('resetEmailMsg', '', ''); setBorder('resetEmailWrapper', 'success'); }

    if (!phone || !/^010-\d{4}-\d{4}$/.test(phone)) { setMsg('resetPhoneMsg', '올바른 전화번호를 입력해주세요. (010-0000-0000)', 'error'); setBorder('resetPhoneWrapper', 'error'); isValid = false; }
    else { setMsg('resetPhoneMsg', '', ''); setBorder('resetPhoneWrapper', 'success'); }

    if (!isValid) return;

    console.log('비밀번호 초기화 요청:', { userId, email, phone });
    const mockFound = true;
    if (mockFound) {
      document.getElementById('resultEmailSent').textContent = maskEmail(email) + ' 으로 발송됨';
      document.getElementById('resetPwForm').style.display = 'none';
      document.getElementById('resetResult').classList.add('show');
    } else {
      setMsg('resetUserIdMsg', '입력하신 정보와 일치하는 계정이 없어요.', 'error');
      setBorder('resetUserIdWrapper', 'error');
    }
  });
}

// ════════════════════════════════════════
// 결혼 예정일 설정 페이지
// ════════════════════════════════════════
if (document.getElementById('calendarDays')) {

  const TODAY_VAL  = new Date();
  const TODAY_YEAR = TODAY_VAL.getFullYear();
  const ITEM_H     = 44;
  const VISIBLE    = 2;
  const MONTHS_KO  = ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'];
  const YEARS      = Array.from({ length: 2099 - TODAY_YEAR + 1 }, (_, i) => TODAY_YEAR + i);

  let viewYear     = TODAY_YEAR;
  let viewMonth    = TODAY_VAL.getMonth();
  let selectedDate = null;

  buildWheel('yearScroller',  YEARS,     viewYear,  onYearChange);
  buildWheel('monthScroller', MONTHS_KO, viewMonth, onMonthChange);
  renderCalendar();

  function buildWheel(scrollerId, items, activeIndex, onChange) {
    const scroller = document.getElementById(scrollerId);
    scroller.innerHTML = '';
    for (let i = 0; i < VISIBLE; i++) { const sp = document.createElement('div'); sp.className = 'wd-wheel-spacer'; scroller.appendChild(sp); }
    items.forEach((label, idx) => {
      const el = document.createElement('div');
      el.className = 'wd-wheel-item' + (idx === activeIndex ? ' active' : '');
      el.textContent = label;
      el.addEventListener('click', () => {
        scroller.scrollTo({ top: idx * ITEM_H, behavior: 'smooth' });
      });
      scroller.appendChild(el);
    });
    for (let i = 0; i < VISIBLE; i++) { const sp = document.createElement('div'); sp.className = 'wd-wheel-spacer'; scroller.appendChild(sp); }
    scroller.scrollTop = activeIndex * ITEM_H;
    let debounce;
    scroller.addEventListener('scroll', () => {
      updateActiveItem(scroller, items, onChange);
      clearTimeout(debounce);
      debounce = setTimeout(() => snapToNearest(scroller), 80);
    });
  }

  function updateActiveItem(scroller, items, onChange) {
    const idx     = Math.round(scroller.scrollTop / ITEM_H);
    const clamped = Math.max(0, Math.min(idx, items.length - 1));
    scroller.querySelectorAll('.wd-wheel-item').forEach((el, i) => el.classList.toggle('active', i === clamped));
    onChange(clamped);
  }

  function snapToNearest(scroller) {
    const idx = Math.round(scroller.scrollTop / ITEM_H);
    scroller.scrollTo({ top: idx * ITEM_H, behavior: 'smooth' });
  }

  function onYearChange(idx)  { viewYear  = YEARS[idx]; document.getElementById('currentYear').textContent  = viewYear + '년';    renderCalendar(); }
  function onMonthChange(idx) { viewMonth = idx;         document.getElementById('currentMonth').textContent = MONTHS_KO[idx]; renderCalendar(); }

  document.getElementById('currentYear').addEventListener('click', e => {
    e.stopPropagation();
    const isOpen = document.getElementById('yearPanel').classList.contains('open');
    closeAllPickers();
    if (!isOpen) { openPicker('yearPanel', 'currentYear'); document.getElementById('yearScroller').scrollTop = YEARS.indexOf(viewYear) * ITEM_H; }
  });

  document.getElementById('currentMonth').addEventListener('click', e => {
    e.stopPropagation();
    const isOpen = document.getElementById('monthPanel').classList.contains('open');
    closeAllPickers();
    if (!isOpen) { openPicker('monthPanel', 'currentMonth'); document.getElementById('monthScroller').scrollTop = viewMonth * ITEM_H; }
  });

  function openPicker(panelId, btnId) { document.getElementById(panelId).classList.add('open'); document.getElementById(btnId).classList.add('open'); }
  function closeAllPickers() {
    ['yearPanel','monthPanel'].forEach(id => document.getElementById(id).classList.remove('open'));
    ['currentYear','currentMonth'].forEach(id => document.getElementById(id).classList.remove('open'));
  }

  document.addEventListener('click', () => closeAllPickers());
  document.getElementById('yearPanel').addEventListener('click',  e => e.stopPropagation());
  document.getElementById('monthPanel').addEventListener('click', e => e.stopPropagation());

  document.getElementById('prevMonth').addEventListener('click', () => {
    closeAllPickers();
    if (viewMonth === 0) { viewYear--; viewMonth = 11; } else { viewMonth--; }
    syncWheels(); renderCalendar();
  });

  document.getElementById('nextMonth').addEventListener('click', () => {
    closeAllPickers();
    if (viewMonth === 11) { viewYear++; viewMonth = 0; } else { viewMonth++; }
    syncWheels(); renderCalendar();
  });

  function syncWheels() {
    const yIdx = YEARS.indexOf(viewYear);
    if (yIdx >= 0) {
      document.getElementById('yearScroller').scrollTop = yIdx * ITEM_H;
      document.getElementById('yearScroller').querySelectorAll('.wd-wheel-item').forEach((el, i) => el.classList.toggle('active', i === yIdx));
    }
    document.getElementById('monthScroller').scrollTop = viewMonth * ITEM_H;
    document.getElementById('monthScroller').querySelectorAll('.wd-wheel-item').forEach((el, i) => el.classList.toggle('active', i === viewMonth));
  }

  function renderCalendar() {
    document.getElementById('currentYear').textContent  = viewYear + '년';
    document.getElementById('currentMonth').textContent = MONTHS_KO[viewMonth];
    const grid = document.getElementById('calendarDays');
    grid.innerHTML = '';
    const today = new Date(); today.setHours(0,0,0,0);
    const firstDay     = new Date(viewYear, viewMonth, 1).getDay();
    const lastDate     = new Date(viewYear, viewMonth + 1, 0).getDate();
    const prevLastDate = new Date(viewYear, viewMonth, 0).getDate();
    for (let i = firstDay - 1; i >= 0; i--) grid.appendChild(makeDay(prevLastDate - i, 'other-month', null));
    for (let d = 1; d <= lastDate; d++) {
      const date       = new Date(viewYear, viewMonth, d);
      const isPast     = date < today;
      const isToday    = date.getTime() === today.getTime();
      const isSelected = selectedDate && date.getTime() === selectedDate.getTime();
      const dow        = date.getDay();
      let cls = '';
      if (dow === 0)  cls += ' sun';
      if (dow === 6)  cls += ' sat';
      if (isToday)    cls += ' today';
      if (isPast)     cls += ' disabled';
      if (isSelected) cls += ' selected';
      grid.appendChild(makeDay(d, cls.trim(), isPast ? null : date));
    }
    const total = firstDay + lastDate;
    const remaining = total % 7 === 0 ? 0 : 7 - (total % 7);
    for (let i = 1; i <= remaining; i++) grid.appendChild(makeDay(i, 'other-month', null));
  }

  function makeDay(num, extraClass, date) {
    const btn = document.createElement('button');
    btn.type = 'button'; btn.textContent = num;
    btn.className = 'wd-day' + (extraClass ? ' ' + extraClass : '');
    if (date) btn.addEventListener('click', () => selectDate(date));
    return btn;
  }

  function selectDate(date) {
    selectedDate = date; renderCalendar(); updateBanner();
    document.getElementById('confirmBtn').disabled = false;
  }

  function updateBanner() {
    if (!selectedDate) return;
    const DAYS_KO = ['일','월','화','수','목','금','토'];
    const y = selectedDate.getFullYear(), m = selectedDate.getMonth()+1, d = selectedDate.getDate();
    const dow = DAYS_KO[selectedDate.getDay()];
    document.getElementById('selectedDateText').textContent = `${y}년 ${m}월 ${d}일 (${dow})`;
    const today = new Date(); today.setHours(0,0,0,0);
    const diff = Math.round((selectedDate - today) / (1000*60*60*24));
    document.getElementById('selectedDday').textContent = diff === 0 ? 'D-Day' : diff > 0 ? `D-${diff}` : `D+${Math.abs(diff)}`;
  }

  document.getElementById('confirmBtn').addEventListener('click', () => {
    if (!selectedDate) return;
    const payload = { weddingDate: selectedDate.toISOString().split('T')[0] };
    console.log('결혼 예정일 저장:', payload);
    alert(`결혼 예정일이 저장되었습니다.\n${payload.weddingDate}\n\n(메인 화면으로 이동 예정)`);
  });

  document.getElementById('skipBtn').addEventListener('click', () => {
    console.log('결혼 예정일 설정 건너뜀');
    alert('나중에 설정할 수 있어요.\n(메인 화면으로 이동 예정)');
  });
}
