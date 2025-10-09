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

    // Business logic to handle which actions are available to the user
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

    // Employee can create drafted expenses, or create and submit them
    const canCreate = () => {
        return user.role === 'employee'
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

    // action handlers

    // submit expense
    const handleSubmitExpense = async (expenseId) => {
        try {
            await api.submitExpense(user.id, expenseId)
            fetchExpenses()
        } catch (error) {
            console.error(error)
            alert(error)
        }
    }

    // delete expense
    const handleDeleteExpense = async (expenseId) => {
        try {
            await api.deleteExpense(user.id, expenseId)
            fetchExpenses()
        } catch (error) {
            console.error(error)
            alert(error)
        }
    }

    // approve expense
    const handleApproveExpense = async (expenseId) => {
        try {
            await api.approveExpense(user.id, expenseId)
            fetchExpenses()
        } catch (error) {
            console.error(error)
            alert(error)
        }
    }

    // reject expense
    const handleRejectExpense = async (expenseId) => {
        try {
            await api.rejectExpense(user.id, expenseId)
            fetchExpenses()
        } catch (error) {
            console.error(error)
            alert(error)
        }
    }

    // apply colors and icons to expenses based on state
    const getStateColor = (state) => {
        switch (state) {
            case 'drafted': return 'bg-amber-100 text-amber-800 border-amber-200'
            case 'submitted': return 'bg-blue-100 text-blue-800 border-blue-200'
            case 'approved': return 'bg-emerald-100 text-emerald-800 border-emerald-200'
            case 'rejected': return 'bg-red-100 text-red-800 border-red-200'
            default: return 'bg-amber-100 text-amber-800 border-amber-200'
        }
    }
    const getStateIcon = (state) => {
        switch (state) {
            case 'drafted': return '📝'
            case 'submitted': return '⏳'
            case 'approved': return '✅'
            case 'rejected': return '❌'
            default: return '📝'
        }
    }

    const formatAmount = (amount) => {
        return (amount / 100).toFixed(2)
    }

    if (loading || !user) {
        return (
            <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50 flex items-center justify-center">
                <div className="text-center">
                    <div className="animate-spin rounded-full h-16 w-16 border-4 border-blue-200 border-t-blue-600 mx-auto"></div>
                    <p className="mt-6 text-slate-600 text-lg font-medium">Loading expenses...</p>
                </div>
            </div>
        )
    }

    return (
        <div className="min-h-screen bg-gradient-to-br from-slate-50 to-blue-50">
            <div className="bg-white shadow-sm border-b border-slate-200">
                <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
                    <div className="flex justify-between items-center">
                        <div>
                            <h1 className="text-2xl font-bold text-slate-900">Expense Management</h1>
                            <p className="text-sm text-slate-600 mt-1">
                                Logged in as <span className="font-medium">{user.name}</span>
                                <span className="ml-2 px-2 py-1 bg-blue-100 text-blue-800 text-xs rounded-full border border-blue-200">
                                    {user.role}
                                </span>
                            </p>
                        </div>
                        <div className="flex gap-3">
                            {canCreate() && (
                                <button
                                    onClick={() => router.push('/expenses/new')}
                                    className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors"
                                >
                                    <svg className="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                                    </svg>
                                    Add Expense
                                </button>
                            )}
                            <button
                                onClick={() => {
                                    logout()
                                    router.push('/')
                                }}
                                className="inline-flex items-center px-4 py-2 border border-slate-300 text-sm font-medium rounded-lg text-slate-700 bg-white hover:bg-slate-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-slate-500 transition-colors"
                            >
                                Switch User
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
                <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
                    <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-6">
                        <div className="flex items-center">
                            <div className="flex-shrink-0">
                                <div className="w-12 h-12 bg-slate-100 rounded-lg flex items-center justify-center">
                                    <span className="text-2xl">📊</span>
                                </div>
                            </div>
                            <div className="ml-4">
                                <p className="text-sm font-medium text-slate-600">Total</p>
                                <p className="text-2xl font-bold text-slate-900">{expenses.length}</p>
                            </div>
                        </div>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-6">
                        <div className="flex items-center">
                            <div className="flex-shrink-0">
                                <div className="w-12 h-12 bg-amber-100 rounded-lg flex items-center justify-center">
                                    <span className="text-2xl">📝</span>
                                </div>
                            </div>
                            <div className="ml-4">
                                <p className="text-sm font-medium text-slate-600">Drafted</p>
                                <p className="text-2xl font-bold text-slate-900">
                                    {expenses.filter(e => e.state === 'drafted').length}
                                </p>
                            </div>
                        </div>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-6">
                        <div className="flex items-center">
                            <div className="flex-shrink-0">
                                <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                                    <span className="text-2xl">⏳</span>
                                </div>
                            </div>
                            <div className="ml-4">
                                <p className="text-sm font-medium text-slate-600">Submitted</p>
                                <p className="text-2xl font-bold text-slate-900">
                                    {expenses.filter(e => e.state === 'submitted').length}
                                </p>
                            </div>
                        </div>
                    </div>

                    <div className="bg-white rounded-xl shadow-sm border border-slate-200 p-6">
                        <div className="flex items-center">
                            <div className="flex-shrink-0">
                                <div className="w-12 h-12 bg-emerald-100 rounded-lg flex items-center justify-center">
                                    <span className="text-2xl">✅</span>
                                </div>
                            </div>
                            <div className="ml-4">
                                <p className="text-sm font-medium text-slate-600">Approved</p>
                                <p className="text-2xl font-bold text-slate-900">
                                    {expenses.filter(e => e.state === 'approved').length}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>

                <div className="bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
                    <div className="px-6 py-4 border-b border-slate-200 bg-slate-50">
                        <h2 className="text-lg font-semibold text-slate-900">
                            {user.role === 'employee' ? 'Your Expenses' : 'Expenses to Review'}
                        </h2>
                        <p className="text-sm text-slate-600 mt-1">
                            {user.role === 'employee'
                                ? 'Manage and track your expense submissions'
                                : 'Review and approve submitted expenses'}
                        </p>
                    </div>

                    {expenses.length === 0 ? (
                        <div className="px-6 py-12 text-center">
                            <div className="w-16 h-16 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-4">
                                <span className="text-3xl">📄</span>
                            </div>
                            <h3 className="text-lg font-medium text-slate-900 mb-2">No expenses found</h3>
                            <p className="text-slate-600 mb-6">
                                {user.role === 'employee'
                                    ? 'Get started by creating your first expense'
                                    : 'No expenses pending review at this time'}
                            </p>
                            {user.role === 'employee' && (
                                <button
                                    onClick={() => router.push('/expenses/new')}
                                    className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-lg text-white bg-blue-600 hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors"
                                >
                                    <svg className="w-4 h-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 6v6m0 0v6m0-6h6m-6 0H6" />
                                    </svg>
                                    Create First Expense
                                </button>
                            )}
                        </div>
                    ) : (
                        <div className="overflow-x-auto">
                            <table className="min-w-full divide-y divide-slate-200">
                                <thead className="bg-slate-50">
                                    <tr>
                                        <th className="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">
                                            Description
                                        </th>
                                        <th className="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">
                                            Amount
                                        </th>
                                        <th className="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">
                                            Status
                                        </th>
                                        <th className="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">
                                            Employee
                                        </th>
                                        <th className="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">
                                            Submitted
                                        </th>
                                        <th className="px-6 py-3 text-left text-xs font-medium text-slate-500 uppercase tracking-wider">
                                            Reviewer
                                        </th>
                                        <th className="px-6 py-3 text-right text-xs font-medium text-slate-500 uppercase tracking-wider">
                                            Actions
                                        </th>
                                    </tr>
                                </thead>
                                <tbody className="bg-white divide-y divide-slate-200">
                                    {expenses.map((expense) => (
                                        <tr key={expense.id} className="hover:bg-slate-50 transition-colors">
                                            <td className="px-6 py-4 text-sm font-medium text-slate-900">
                                                {expense.description}
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap text-sm text-slate-900 font-semibold">
                                                ${formatAmount(expense.amount)}
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap">
                                                <span className={`inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium border ${getStateColor(expense.state)}`}>
                                                    <span className="mr-1">{getStateIcon(expense.state)}</span>
                                                    {expense.state}
                                                </span>
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap text-sm text-slate-600">
                                                {expense.employee.name}
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap text-sm text-slate-600">
                                                {expense.submitted_at ? new Date(expense.submitted_at).toLocaleDateString() : '-'}
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap text-sm text-slate-600">
                                                {expense.reviewer ? expense.reviewer.name : '-'}
                                            </td>
                                            <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                                <div className="flex justify-end gap-2">
                                                    {canSubmit(expense) && (
                                                        <button
                                                            onClick={() => handleSubmitExpense(expense.id)}
                                                            className="text-blue-600 hover:text-blue-900 hover:underline"
                                                        >
                                                            Submit
                                                        </button>
                                                    )}
                                                    {canEdit(expense) && (
                                                        <button
                                                            onClick={() => router.push(`/expenses/${expense.id}/edit`)}
                                                            className="text-indigo-600 hover:text-indigo-900 hover:underline"
                                                        >
                                                            Edit
                                                        </button>
                                                    )}
                                                    {canDelete(expense) && (
                                                        <button
                                                            onClick={() => handleDeleteExpense(expense.id)}
                                                            className="text-red-600 hover:text-red-900 hover:underline"
                                                        >
                                                            Delete
                                                        </button>
                                                    )}
                                                    {canApprove(expense) && (
                                                        <button
                                                            onClick={() => handleApproveExpense(expense.id)}
                                                            className="text-emerald-600 hover:text-emerald-900 hover:underline"
                                                        >
                                                            Approve
                                                        </button>
                                                    )}
                                                    {canReject(expense) && (
                                                        <button
                                                            onClick={() => handleRejectExpense(expense.id)}
                                                            className="text-red-600 hover:text-red-900 hover:underline"
                                                        >
                                                            Reject
                                                        </button>
                                                    )}
                                                </div>
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        </div>
                    )}
                </div>
            </div>
        </div>
    )
}
