'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { useUser } from '../contexts/UserContext'

export default function Expenses() {
    const { user, logout } = useUser()
    const router = useRouter()
    const [loading, setLoading] = useState(true)

    useEffect(() => {
        if (!user) {
            router.push('/')
        } else {
            console.log('user: ', user)
            setLoading(false)
        }
    }, [user, router])

    if (loading || !user) {
        return <div>Loading...</div>
    }

    return (
        <div>
            <h1>Expenses</h1>
            <p>Welcome, {user.name}</p>
            <p>Email: {user.email}</p>
            <p>Role: {user.role}</p>
            <button onClick={() => logout()}>Logout</button>
        </div>
    )
}
