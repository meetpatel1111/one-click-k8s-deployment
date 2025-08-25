const balanceEl = document.getElementById('balance');
const incomeEl = document.getElementById('income');
const expensesEl = document.getElementById('expenses');
const transactionList = document.getElementById('transaction-list');
const addBtn = document.getElementById('addBtn');
const descriptionEl = document.getElementById('description');
const amountEl = document.getElementById('amount');
const typeEl = document.getElementById('type');

// Base API path
const API_BASE = '/mini-budget-tracker/api';

let transactions = [];

// Fetch transactions from backend
async function fetchTransactions() {
    try {
        const res = await fetch(`${API_BASE}/transactions`);
        transactions = await res.json();
        updateUI();
    } catch (err) {
        console.error('Error fetching transactions:', err);
    }
}

// Add transaction via backend
async function addTransaction(description, amount, type) {
    try {
        await fetch(`${API_BASE}/transactions`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ description, amount, type })
        });
        await fetchTransactions();
    } catch (err) {
        console.error('Error adding transaction:', err);
    }
}

// Delete transaction via backend
async function deleteTransaction(index) {
    try {
        await fetch(`${API_BASE}/transactions/${index}`, { method: 'DELETE' });
        await fetchTransactions();
    } catch (err) {
        console.error('Error deleting transaction:', err);
    }
}

// Update UI
function updateUI() {
    transactionList.innerHTML = '';
    let income = 0;
    let expenses = 0;

    transactions.forEach((t, index) => {
        const li = document.createElement('li');
        li.classList.add(t.type);
        li.innerHTML = `
            ${t.description} <span>$${t.amount}</span> 
            <button onclick="deleteTransaction(${index})">x</button>
        `;
        transactionList.appendChild(li);

        if (t.type === 'income') income += t.amount;
        else expenses += t.amount;
    });

    balanceEl.textContent = (income - expenses).toFixed(2);
    incomeEl.textContent = income.toFixed(2);
    expensesEl.textContent = expenses.toFixed(2);
}

// Event listener for add button
addBtn.addEventListener('click', () => {
    const description = descriptionEl.value.trim();
    const amount = parseFloat(amountEl.value);
    const type = typeEl.value;

    if (description && !isNaN(amount)) {
        addTransaction(description, amount, type);
        descriptionEl.value = '';
        amountEl.value = '';
    }
});

// Initial fetch
fetchTransactions();
