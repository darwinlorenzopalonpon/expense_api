'use client'

import { useEffect, useState } from 'react'
import { useRouter } from 'next/navigation'
import { useUser } from '../contexts/UserContext'
import Api from '../lib/api'

export default function Expenses() {
    const { user, logout } = useUser()
    const router = useRouter()
    const [loading, setLoading] = useState(true)
    const [expenses, setExpenses] = useState([])
    const api = new Api()

    useEffect(() => {
        if (!user) {
            router.push('/')
            return
        }
        fetchExpenses()
    }, [user, router])

    const fetchExpenses = async () => {
        try {
            const data = await api.fetchExpenses(user.id)
            setExpenses(data)
        } catch (error) {
            console.error('Error fetching expenses: ', error)
        } finally {
            setLoading(false)
        }
    }

    // Business logic Start
    // handles which actions are available to the user
    // depending on their role and ID, as well as the state of the expense
    // some redundancy present for readability

    // Employee can only edit drafted expenses that belong to them
    const canEdit = (expense) => {
        return expense.state === 'drafted' &&
            expense.employee.id === user.id &&
            user.role === 'employee'
    }

    // Employee can only submit drafted expenses that belong to them
    const canSubmit = (expense) => {
        return expense.state === 'drafted' &&
            expense.employee.id === user.id &&
            user.role === 'employee'
    }

    // Employee can only delete drafted expenses that belong to them
    const canDelete = (expense) => {
        return expense.state === 'drafted' &&
            expense.employee.id === user.id &&
            user.role === 'employee'
    }

    // Reviewer can only approve or reject submitted expenses
    const canApprove = (expense) => {
        return expense.state === 'submitted' &&
            user.role === 'reviewer'
    }
    const canReject = (expense) => {
        return expense.state === 'submitted' &&
            user.role === 'reviewer'
    }

    // Business logic End

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
            <div>
                <table>
                    <thead>
                        <tr>
                            <th>Description</th>
                            <th>Amount</th>
                            <th>State</th>
                            <th>Submitted at</th>
                            <th>Reviewed at</th>
                            <th>Employee</th>
                            <th>Reviewer</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        {expenses.map((expense) => (
                            <tr key={expense.id}>
                                <td>{expense.description}</td>
                                <td>{expense.amount}</td>
                                <td>{expense.state}</td>
                                <td>{expense.submitted_at}</td>
                                <td>{expense.reviewed_at}</td>
                                <td>{expense.employee.name}</td>
                                <td>{expense.reviewer?.name}</td>
                                <td>

                                </td>
                            </tr>
                        ))}
                    </tbody>
                </table>
                {expenses.length === 0 && <p>No expenses found</p>}
            </div>
        </div>
    )
}
