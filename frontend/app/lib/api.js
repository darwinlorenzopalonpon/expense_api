const API_URL = process.env.NEXT_PUBLIC_API_URL || ''

class Api {
    constructor() {
        this.apiUrl = API_URL
    }

    getApiUrl(path) {
        return `${this.apiUrl}${path}`
    }

    fetchWithUserId(path, userId) {
        return fetch(`${this.getApiUrl(path)}`, {
            headers: {
                'X-User-ID': userId
            }
        })
    }

    // fetch users
    async fetchUsers() {
        const response = await fetch(this.getApiUrl('/api/v1/users'))
        return response.json()
    }

    // fetch expenses
    async fetchExpenses(userId) {
        const response = await this.fetchWithUserId('/api/v1/expenses', userId)
        return response.json()
    }

}

export default Api
