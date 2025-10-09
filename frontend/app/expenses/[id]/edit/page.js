'use client'

import { useState, useEffect } from 'react'
import { useRouter, useParams } from 'next/navigation'
import { useUser } from '../../../contexts/UserContext'
import Api from '../../../lib/api'

export default function EditExpense() {
    const { user } = useUser()
    const router = useRouter()
    const [loading, setLoading] = useState(true)
    const params = useParams()
    const api = new Api()
    const [error, setError] = useState('')
    const [amount, setAmount] = useState('')
    const [description, setDescription] = useState('')

    useEffect(() => {
        if (!user) {
            router.push('/')
            return
        }
        fetchExpense()
    }, [user, params.id])

    const fetchExpense = async () => {
        if (!params.id) {
            setError('Expense ID is required')
            return
        }
        try {
            const data = await api.fetchExpense(user.id, params.id)
            setAmount(data.amount)
            setDescription(data.description)
        } catch (error) {
            console.error(error)
            setError(error.message || 'Failed to fetch expense')
        } finally {
            setLoading(false)
        }
    }

    const handleSubmit = async (e) => {
        e.preventDefault()
        setLoading(true)

        try {
            await api.updateExpense(user.id,
                {
                    id: params.id,
                    amount: parseFloat(amount),
                    description: description
                }
            )
            router.push('/expenses')
        } catch (error) {
            setError(error.message || 'Failed to update expense')
        } finally {
            setLoading(false)
        }
    }

    return (
        <div className="p-5">
            <h1 className="text-2xl font-bold mb-4">Edit Expense</h1>

            {error && (
                <div className="text-red-600 mb-3">
                    {error}
                </div>
            )}

            <form onSubmit={handleSubmit}>
                <div className="mb-4">
                    <label className="block mb-1">Description:</label>
                    <textarea
                        value={description}
                        onChange={(e) => setDescription(e.target.value)}
                        className="w-full p-2 border border-gray-300 rounded"
                        rows="3"
                        required
                    />
                </div>

                <div className="mb-4">
                    <label className="block mb-1">Amount (in cents):</label>
                    <input
                        type="number"
                        step="1"
                        min="1"
                        value={amount}
                        onChange={(e) => setAmount(e.target.value)}
                        className="w-full p-2 border border-gray-300 rounded"
                        required
                    />
                </div>

                <div>
                    <button
                        type="submit"
                        disabled={loading}
                        className="mr-3 px-3 py-1 bg-blue-500 text-white rounded disabled:bg-gray-400"
                    >
                        {loading ? 'Saving...' : 'Save'}
                    </button>
                    <button
                        type="button"
                        onClick={() => router.push('/expenses')}
                        className="px-3 py-1 bg-gray-300 text-gray-700 rounded"
                    >
                        Cancel
                    </button>
                </div>
            </form>
        </div>
    )
}
