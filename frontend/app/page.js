'use client'

import { useState, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { useUser } from './contexts/UserContext'

export default function Home() {
    const [users, setUsers] = useState([])
    const [loading, setLoading] = useState(true)
    const router = useRouter()
    const { login } = useUser()

    useEffect(() => {
        fetchUsers()
    }, [])

    // fetches users from the API
    const fetchUsers = async () => {
        try {
            const apiUrl = process.env.NEXT_PUBLIC_API_URL || ''
            const response = await fetch(`${apiUrl}/api/v1/users`)
            console.log('response: ', response)
            const data = await response.json()
            console.log('data: ', data)
            setUsers(data)
        } catch (error) {
            console.error('Error fetching users:', error)
        } finally {
            setLoading(false)
        }
    }

    // logs the user in and redirects to the expenses page
    const handleUserSelect = (userId) => {
        const selectedUser = users.find((user) => user.id === userId)
        login(selectedUser)
        router.push('/expenses')
    }

    const getRoleColor = (role) => {
        switch (role) {
            case 'employee': return 'bg-blue-100 text-blue-800 border-blue-200'
            case 'reviewer': return 'bg-purple-100 text-purple-800 border-purple-200'
            default: return 'bg-gray-100 text-gray-800 border-gray-200'
        }
    }

    const getRoleIcon = (role) => {
        switch (role) {
            case 'employee': return '👤'
            case 'reviewer': return '👨‍💼'
            default: return '👤'
        }
    }

    if (loading) {
        return (
            <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50 flex items-center justify-center">
                <div className="text-center">
                    <div className="animate-spin rounded-full h-16 w-16 border-4 border-blue-200 border-t-blue-600 mx-auto"></div>
                    <p className="mt-6 text-slate-600 text-lg font-medium">Loading users...</p>
                </div>
            </div>
        )
    }

    return (
        <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50 flex items-center justify-center p-4">
            <div className="max-w-2xl w-full">

                <div className="text-center mb-8">
                    <div className="w-20 h-20 bg-blue-600 rounded-full flex items-center justify-center mx-auto mb-4 shadow-lg">
                        <span className="text-3xl text-white">💰</span>
                    </div>
                    <h1 className="text-4xl font-bold text-slate-900 mb-2">Expense Management</h1>
                    <p className="text-xl text-slate-600">Select your account to continue</p>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-8">
                    {users.map((user) => (
                        <button
                            key={user.id}
                            onClick={() => handleUserSelect(user.id)}
                            className="p-6 text-left border-2 rounded-xl transition-all duration-200 hover:shadow-lg hover:scale-105 border-slate-200 bg-white hover:border-blue-300 hover:bg-blue-50"
                        >
                            <div className="flex items-start space-x-4">
                                <div className="flex-shrink-0">
                                    <div className="w-12 h-12 bg-slate-100 rounded-full flex items-center justify-center">
                                        <span className="text-2xl">{getRoleIcon(user.role)}</span>
                                    </div>
                                </div>
                                <div className="flex-1 min-w-0">
                                    <h3 className="text-lg font-semibold text-slate-900 mb-1">
                                        {user.name}
                                    </h3>
                                    <p className="text-sm text-slate-600 mb-2">{user.email}</p>
                                    <span className={`inline-flex items-center px-3 py-1 rounded-full text-xs font-medium border ${getRoleColor(user.role)}`}>
                                        {user.role}
                                    </span>
                                </div>
                            </div>
                        </button>
                    ))}
                </div>

                <div className="text-center mt-8">
                    <p className="text-sm text-slate-500">
                        Select an account
                    </p>
                </div>
            </div>
        </div>
    )
}
