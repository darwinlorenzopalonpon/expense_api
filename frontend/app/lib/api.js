const API_URL = 'http://localhost:3000'

class Api {
    constructor() {
        this.apiUrl = API_URL
    }

    getApiUrl(path) {
        return `${this.apiUrl}${path}`
    }

    async request(path, options) {
        const response = await fetch(this.getApiUrl(path), options)
        if (!response.ok) {
            let errorMessage = `HTTP error ${response.status} ${response.statusText}`
            try {
                const errorData = await response.json()
                if (errorData.error) {
                    errorMessage = `${errorMessage} - ${errorData.error}`
                }
            } catch (e) {
                console.error('Error parsing error response: ', e)
            }
            throw new Error(errorMessage)
        }

        return response.json()
    }

    // fetch users
    async fetchUsers() {
        return this.request('/api/v1/users')
    }

    // fetch expenses
    async fetchExpenses(userId) {
        return this.request('/api/v1/expenses', {
            headers: {
                'X-User-ID': userId
            }
        })
    }

    // fetch expense
    async fetchExpense(userId, expenseId) {
        return this.request(`/api/v1/expenses/${expenseId}`, {
            headers: {
                'X-User-ID': userId
            }
        })
    }

    // create expense
    async createExpense(userId, data) {
        return this.request('/api/v1/expenses', {
            headers: {
                'Content-Type': 'application/json',
                'X-User-ID': userId
            },
            method: 'POST',
            body: JSON.stringify({ expense: data })
        })
    }

    // update expense
    async updateExpense(userId, data) {
        return this.request(`/api/v1/expenses/${data.id}`, {
            headers: {
                'Content-Type': 'application/json',
                'X-User-ID': userId
            },
            method: 'PATCH',
            body: JSON.stringify({ expense: data })
        })
    }

    // delete expense
    async deleteExpense(userId, expenseId) {
        return this.request(`/api/v1/expenses/${expenseId}`, {
            headers: {
                'X-User-ID': userId
            },
            method: 'DELETE'
        })
    }

    // submit expense
    async submitExpense(userId, expenseId) {
        return this.request(`/api/v1/expenses/${expenseId}/submit`, {
            headers: {
                'X-User-ID': userId
            },
            method: 'POST'
        })
    }

    // approve expense
    async approveExpense(userId, expenseId) {
        return this.request(`/api/v1/expenses/${expenseId}/approve`, {
            headers: {
                'X-User-ID': userId
            },
            method: 'POST'
        })
    }

    // reject expense
    async rejectExpense(userId, expenseId) {
        return this.request(`/api/v1/expenses/${expenseId}/reject`, {
            headers: {
                'X-User-ID': userId
            },
            method: 'POST'
        })
    }
}

export default Api
