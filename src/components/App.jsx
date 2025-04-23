
import Login from './Login'; // src/components/Login.jsx
import { useState, useEffect } from 'react';
import AddUserForm from './AddUserForm';
import ChangePasswordForm from './ChangePasswordForm';

export default function App() {
  const [tab, setTab] = useState('home');
  const [user, setUser] = useState(null);

  useEffect(() => {
    const stored = localStorage.getItem('currentUser');
    if (stored) setUser(JSON.parse(stored));
  }, []);

if (!user) {
  return <Login onLogin={setUser} />; // login хуудас ачаална
}
  return (
    <div className="app">
      <aside className="sidebar">
        <h2>📋 Цэс</h2>
        <button onClick={() => setTab('home')}>🏠 Нүүр</button>
        {user.role === 'admin' && (
          <button onClick={() => setTab('add-user')}>👤 Хэрэглэгч нэмэх</button>
        )}
        <button onClick={() => setTab('change-password')}>🔐 Нууц үг солих</button>
      </aside>
      <main className="main">
        {tab === 'home' && <h2>🎉 Тавтай морилно уу, {user.name}</h2>}
        {tab === 'add-user' && <AddUserForm currentUser={user} />}
        {tab === 'change-password' && <ChangePasswordForm currentUser={user} />}
      </main>
    </div>
  );
}
