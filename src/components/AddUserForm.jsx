
import { useState } from 'react';

export default function AddUserForm({ currentUser }) {
  const [form, setForm] = useState({ email: '', password: '', name: '', role: 'user' });
  const [message, setMessage] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    const res = await fetch('/api/add-user', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ ...form, adminId: currentUser?.id })
    });
    const data = await res.json();
    setMessage(data.message || 'Амжилтгүй боллоо');
  };

  return (
    <div>
      <h2>👤 Шинэ хэрэглэгч нэмэх</h2>
      <form onSubmit={handleSubmit}>
        <input placeholder="Имэйл" value={form.email} onChange={e => setForm({ ...form, email: e.target.value })} required />
        <input placeholder="Нууц үг" type="password" value={form.password} onChange={e => setForm({ ...form, password: e.target.value })} required />
        <input placeholder="Нэр" value={form.name} onChange={e => setForm({ ...form, name: e.target.value })} required />
        <select value={form.role} onChange={e => setForm({ ...form, role: e.target.value })}>
          <option value="user">Хэрэглэгч</option>
          <option value="admin">Админ</option>
        </select>
        <button type="submit">Нэмэх</button>
      </form>
      {message && <p>{message}</p>}
    </div>
  );
}
