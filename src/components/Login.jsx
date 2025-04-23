import { useState } from 'react';

export default function Login({ onLogin }) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [msg, setMsg] = useState('');

  const handleLogin = async () => {
    try {
      const res = await fetch('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, password }),
      });

      const data = await res.json();
      if (!res.ok) return setMsg(data.message || 'Алдаа гарлаа');

      localStorage.setItem('currentUser', JSON.stringify(data.user));
      onLogin(data.user);
    } catch (err) {
      setMsg('Сервертэй холбогдоход алдаа гарлаа');
    }
  };

  return (
    <div>
      <h2>Нэвтрэх</h2>
      {msg && <p style={{ color: 'red' }}>{msg}</p>}
      <input value={email} onChange={e => setEmail(e.target.value)} placeholder="Имэйл" />
      <input type="password" value={password} onChange={e => setPassword(e.target.value)} placeholder="Нууц үг" />
      <button onClick={handleLogin}>Нэвтрэх</button>
    </div>
  );
}
