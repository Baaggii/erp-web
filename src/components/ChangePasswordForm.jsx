
import { useState } from 'react';

export default function ChangePasswordForm({ currentUser }) {
  const [form, setForm] = useState({ oldPassword: '', newPassword: '' });
  const [message, setMessage] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    const res = await fetch('/api/change-password', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ userId: currentUser?.id, ...form })
    });
    const data = await res.json();
    setMessage(data.message || 'Амжилтгүй боллоо');
  };

  return (
    <div>
      <h2>🔐 Нууц үг солих</h2>
      <form onSubmit={handleSubmit}>
        <input type="password" placeholder="Хуучин нууц үг" value={form.oldPassword} onChange={e => setForm({ ...form, oldPassword: e.target.value })} required />
        <input type="password" placeholder="Шинэ нууц үг" value={form.newPassword} onChange={e => setForm({ ...form, newPassword: e.target.value })} required />
        <button type="submit">Солих</button>
      </form>
      {message && <p>{message}</p>}
    </div>
  );
}
