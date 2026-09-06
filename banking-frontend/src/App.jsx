import { useEffect, useState } from "react";
import axios from "axios";
import {
  BarChart,
  Bar,
  LineChart,
  Line,
  PieChart,
  Pie,
  Cell,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  ResponsiveContainer,
  Legend
} from "recharts";
import "./App.css";

const API = "http://localhost:8080/api";

function App() {
  const [page, setPage] = useState("dashboard");

  const [summary, setSummary] = useState({});
  const [topCustomers, setTopCustomers] = useState([]);
  const [monthlyTransactions, setMonthlyTransactions] = useState([]);
  const [transactionTypes, setTransactionTypes] = useState([]);
  const [branchPerformance, setBranchPerformance] = useState([]);
  const [loanExposure, setLoanExposure] = useState([]);
  const [customerSummary, setCustomerSummary] = useState([]);

  const [customers, setCustomers] = useState([]);
  const [accounts, setAccounts] = useState([]);
  const [transactions, setTransactions] = useState([]);
  const [loans, setLoans] = useState([]);

  const [loading, setLoading] = useState(true);

  const formatMoney = (value) =>
    `₹${Number(value || 0).toLocaleString("en-IN")}`;

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      const responses = await Promise.all([
        axios.get(`${API}/analytics/summary`),
        axios.get(`${API}/analytics/top-customers`),
        axios.get(`${API}/analytics/monthly-transactions`),
        axios.get(`${API}/analytics/transaction-types`),
        axios.get(`${API}/analytics/branch-performance`),
        axios.get(`${API}/analytics/loan-exposure`),
        axios.get(`${API}/analytics/customer-financial-summary`),
        axios.get(`${API}/customers`),
        axios.get(`${API}/accounts`),
        axios.get(`${API}/transactions`),
        axios.get(`${API}/loans`)
      ]);

      setSummary(responses[0].data);
      setTopCustomers(responses[1].data);

      setMonthlyTransactions(
        responses[2].data.map((item) => ({
          month: item[0],
          count: Number(item[1]),
          amount: Number(item[2])
        }))
      );

      setTransactionTypes(
        responses[3].data.map((item) => ({
          type: item[0],
          count: Number(item[1]),
          amount: Number(item[2])
        }))
      );

      setBranchPerformance(
        responses[4].data.map((item) => ({
          branch: item[1],
          accounts: Number(item[2]),
          balance: Number(item[3]),
          transactions: Number(item[4]),
          amount: Number(item[5])
        }))
      );

      setLoanExposure(
        responses[5].data.map((item) => ({
          type: item[0],
          count: Number(item[1]),
          loanAmount: Number(item[2]),
          outstanding: Number(item[3])
        }))
      );

      setCustomerSummary(
        responses[6].data.map((item) => ({
          id: item[0],
          name: item[1],
          balance: Number(item[2]),
          accounts: Number(item[3]),
          transactions: Number(item[4]),
          outstanding: Number(item[5])
        }))
      );

      setCustomers(responses[7].data);
      setAccounts(responses[8].data);
      setTransactions(responses[9].data);
      setLoans(responses[10].data);

      setLoading(false);
    } catch (error) {
      console.error("Failed to load data:", error);
      setLoading(false);
    }
  };

  const lowBalanceAccounts = accounts.filter(
    (account) => Number(account.balance || 0) < 50000
  );

  const highActivityCustomers = [...customerSummary]
    .sort((a, b) => b.transactions - a.transactions)
    .slice(0, 5);

  const highLoanCustomers = [...customerSummary]
    .filter((customer) => Number(customer.outstanding || 0) > 0)
    .sort((a, b) => b.outstanding - a.outstanding)
    .slice(0, 5);

  const Dashboard = () => (
    <>
      <div className="page-title">
        <h1>Dashboard</h1>
        <p>Banking customer and transaction analytics</p>
      </div>

      <section className="cards">
        <div className="card">
          <span>Total Customers</span>
          <strong>{summary.totalCustomers || 0}</strong>
        </div>

        <div className="card">
          <span>Total Accounts</span>
          <strong>{summary.totalAccounts || 0}</strong>
        </div>

        <div className="card">
          <span>Total Balance</span>
          <strong>{formatMoney(summary.totalBalance)}</strong>
        </div>

        <div className="card">
          <span>Total Transactions</span>
          <strong>{summary.totalTransactions || 0}</strong>
        </div>

        <div className="card">
          <span>Total Loans</span>
          <strong>{summary.totalLoans || 0}</strong>
        </div>

        <div className="card">
          <span>Outstanding Loans</span>
          <strong>{formatMoney(summary.totalOutstandingLoans)}</strong>
        </div>
      </section>

      <section className="insights-grid">
        <div className="panel">
          <h2>High Activity Customers</h2>
          {highActivityCustomers.map((customer) => (
            <div className="insight-row" key={customer.id}>
              <span>{customer.name}</span>
              <strong>{customer.transactions} transactions</strong>
            </div>
          ))}
        </div>

        <div className="panel">
          <h2>High Loan Exposure</h2>
          {highLoanCustomers.map((customer) => (
            <div className="insight-row" key={customer.id}>
              <span>{customer.name}</span>
              <strong>{formatMoney(customer.outstanding)}</strong>
            </div>
          ))}
        </div>

        <div className="panel">
          <h2>Low Balance Accounts</h2>
          <div className="insight-highlight">
            {lowBalanceAccounts.length} accounts below ₹50,000
          </div>
        </div>
      </section>

      <section className="chart-grid">
        <div className="panel large">
          <h2>Monthly Transaction Activity</h2>

          <ResponsiveContainer width="100%" height={320}>
            <LineChart data={monthlyTransactions}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="month" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Line
                type="monotone"
                dataKey="count"
                name="Transactions"
                strokeWidth={3}
              />
            </LineChart>
          </ResponsiveContainer>
        </div>

        <div className="panel">
          <h2>Transaction Types</h2>

          <ResponsiveContainer width="100%" height={320}>
            <PieChart>
              <Pie
                data={transactionTypes}
                dataKey="count"
                nameKey="type"
                cx="50%"
                cy="50%"
                outerRadius={100}
                label
              >
                {transactionTypes.map((entry, index) => {
  const colors = ["#2563eb", "#16a34a", "#f59e0b"];

  return (
    <Cell
      key={entry.type}
      fill={colors[index % colors.length]}
    />
  );
})}
              </Pie>

              <Tooltip />
              <Legend />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </section>

      <section className="chart-grid">
        <div className="panel">
          <h2>Branch Performance</h2>

          <ResponsiveContainer width="100%" height={320}>
            <BarChart data={branchPerformance}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="branch" />
              <YAxis />
              <Tooltip />
              <Bar dataKey="transactions" name="Transactions" />
            </BarChart>
          </ResponsiveContainer>
        </div>

        <div className="panel">
          <h2>Loan Exposure</h2>

          <ResponsiveContainer width="100%" height={320}>
            <BarChart data={loanExposure}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="type" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Bar dataKey="loanAmount" name="Loan Amount" />
              <Bar dataKey="outstanding" name="Outstanding" />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </section>
    </>
  );

  const Customers = () => {
    const [search, setSearch] = useState("");
    const [selectedCustomer, setSelectedCustomer] = useState(null);

    const filteredCustomers = customers.filter((customer) => {
      const value = `${customer.firstName} ${customer.lastName} ${customer.email} ${customer.city}`.toLowerCase();
      return value.includes(search.toLowerCase());
    });

    const customerAccounts = selectedCustomer
      ? accounts.filter((account) => account.customerId === selectedCustomer.customerId)
      : [];

    const customerLoans = selectedCustomer
      ? loans.filter((loan) => loan.customerId === selectedCustomer.customerId)
      : [];

    const customerTransactions = selectedCustomer
      ? transactions.filter((transaction) =>
          customerAccounts.some((account) => account.accountId === transaction.accountId)
        )
      : [];

    return (
      <>
        <div className="page-title">
          <h1>Customers</h1>
          <p>Search customers and view their financial activity</p>
        </div>

        <div className="panel">
          <input
            className="search-input"
            type="text"
            value={search}
            onChange={(event) => setSearch(event.target.value)}
            placeholder="Search by name, email or city"
          />
        </div>

        {selectedCustomer && (
          <div className="panel customer-details">
            <div className="detail-header">
              <div>
                <h2>{selectedCustomer.firstName} {selectedCustomer.lastName}</h2>
                <p>Customer ID: {selectedCustomer.customerId}</p>
              </div>
              <button className="close-button" onClick={() => setSelectedCustomer(null)}>
                Close
              </button>
            </div>

            <div className="detail-grid">
              <div><strong>Email</strong><span>{selectedCustomer.email}</span></div>
              <div><strong>Phone</strong><span>{selectedCustomer.phone}</span></div>
              <div><strong>City</strong><span>{selectedCustomer.city}</span></div>
              <div><strong>Date of Birth</strong><span>{selectedCustomer.dateOfBirth}</span></div>
            </div>

            <h3>Accounts</h3>
            <div className="table-wrapper">
              <table>
                <thead>
                  <tr>
                    <th>Account ID</th>
                    <th>Type ID</th>
                    <th>Balance</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  {customerAccounts.map((account) => (
                    <tr key={account.accountId}>
                      <td>{account.accountId}</td>
                      <td>{account.accountTypeId}</td>
                      <td>{formatMoney(account.balance)}</td>
                      <td><span className="badge">{account.status}</span></td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            <h3>Loans</h3>
            <div className="table-wrapper">
              <table>
                <thead>
                  <tr>
                    <th>Loan Type</th>
                    <th>Loan Amount</th>
                    <th>Outstanding</th>
                    <th>Status</th>
                  </tr>
                </thead>
                <tbody>
                  {customerLoans.length > 0 ? customerLoans.map((loan) => (
                    <tr key={loan.loanId}>
                      <td>{loan.loanType}</td>
                      <td>{formatMoney(loan.loanAmount)}</td>
                      <td>{formatMoney(loan.outstandingAmount)}</td>
                      <td><span className="badge">{loan.status}</span></td>
                    </tr>
                  )) : (
                    <tr><td colSpan="4">No loans found.</td></tr>
                  )}
                </tbody>
              </table>
            </div>

            <p className="customer-activity">
              Transaction activity: <strong>{customerTransactions.length}</strong> transactions
            </p>
          </div>
        )}

        <div className="panel">
          <div className="table-wrapper">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Name</th>
                  <th>Date of Birth</th>
                  <th>Phone</th>
                  <th>Email</th>
                  <th>City</th>
                  <th>Details</th>
                </tr>
              </thead>
              <tbody>
                {filteredCustomers.map((customer) => (
                  <tr key={customer.customerId}>
                    <td>{customer.customerId}</td>
                    <td>{customer.firstName} {customer.lastName}</td>
                    <td>{customer.dateOfBirth}</td>
                    <td>{customer.phone}</td>
                    <td>{customer.email}</td>
                    <td>{customer.city}</td>
                    <td>
                      <button
                        className="details-button"
                        onClick={() => setSelectedCustomer(customer)}
                      >
                        View
                      </button>
                    </td>
                  </tr>
                ))}
                {filteredCustomers.length === 0 && (
                  <tr><td colSpan="7">No customers found.</td></tr>
                )}
              </tbody>
            </table>
          </div>
        </div>
      </>
    );
  };

  const Accounts = () => (
    <>
      <div className="page-title">
        <h1>Accounts</h1>
        <p>Customer bank accounts</p>
      </div>

      <div className="panel">
        <div className="table-wrapper">
          <table>
            <thead>
              <tr>
                <th>Account ID</th>
                <th>Customer ID</th>
                <th>Branch ID</th>
                <th>Type ID</th>
                <th>Opening Date</th>
                <th>Balance</th>
                <th>Status</th>
              </tr>
            </thead>

            <tbody>
              {accounts.map((account) => (
                <tr key={account.accountId}>
                  <td>{account.accountId}</td>
                  <td>{account.customerId}</td>
                  <td>{account.branchId}</td>
                  <td>{account.accountTypeId}</td>
                  <td>{account.openingDate}</td>
                  <td>{formatMoney(account.balance)}</td>
                  <td>
                    <span className="badge">{account.status}</span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );

  const Transactions = () => {
    const [operation, setOperation] = useState("deposit");
    const [accountId, setAccountId] = useState("");
    const [destinationAccountId, setDestinationAccountId] = useState("");
    const [amount, setAmount] = useState("");
    const [description, setDescription] = useState("");
    const [message, setMessage] = useState("");
    const [error, setError] = useState("");
    const [transactionSearch, setTransactionSearch] = useState("");
    const [transactionTypeFilter, setTransactionTypeFilter] = useState("ALL");

    const handleTransaction = async (event) => {
      event.preventDefault();

      setMessage("");
      setError("");

      try {
        if (operation === "transfer") {
          await axios.post(`${API}/transactions/transfer`, null, {
            params: {
              sourceAccountId: Number(accountId),
              destinationAccountId: Number(destinationAccountId),
              amount: Number(amount)
            }
          });
        } else {
          await axios.post(
            `${API}/transactions/${
              operation === "deposit" ? "deposit" : "withdraw"
            }`,
            null,
            {
              params: {
                accountId: Number(accountId),
                amount: Number(amount),
                description: description || undefined
              }
            }
          );
        }

        setMessage("Transaction completed successfully.");

        setAccountId("");
        setDestinationAccountId("");
        setAmount("");
        setDescription("");

        await loadData();
      } catch (error) {
        console.error("Transaction failed:", error);

        const backendMessage =
          error.response?.data?.message ||
          error.response?.data ||
          "Transaction failed.";

        setError(String(backendMessage));
      }
    };

    const filteredTransactions = transactions
      .slice()
      .reverse()
      .filter((transaction) => {
        const value = `${transaction.accountId} ${transaction.transactionId} ${transaction.description || ""}`.toLowerCase();
        return (
          value.includes(transactionSearch.toLowerCase()) &&
          (transactionTypeFilter === "ALL" ||
            transaction.transactionType === transactionTypeFilter)
        );
      });

    return (
      <>
        <div className="page-title">
          <h1>Transactions</h1>
          <p>Manage and view banking transactions</p>
        </div>

        <div className="panel transaction-form">
          <h2>Perform Transaction</h2>

          <div className="operation-buttons">
            <button
              type="button"
              className={operation === "deposit" ? "selected" : ""}
              onClick={() => {
                setOperation("deposit");
                setMessage("");
                setError("");
              }}
            >
              Deposit
            </button>

            <button
              type="button"
              className={operation === "withdraw" ? "selected" : ""}
              onClick={() => {
                setOperation("withdraw");
                setMessage("");
                setError("");
              }}
            >
              Withdraw
            </button>

            <button
              type="button"
              className={operation === "transfer" ? "selected" : ""}
              onClick={() => {
                setOperation("transfer");
                setMessage("");
                setError("");
              }}
            >
              Transfer
            </button>
          </div>

          <form onSubmit={handleTransaction}>
            <div className="form-grid">
              <div>
                <label>
                  {operation === "transfer"
                    ? "Source Account ID"
                    : "Account ID"}
                </label>

                <input
                  type="number"
                  value={accountId}
                  onChange={(event) => setAccountId(event.target.value)}
                  placeholder="Example: 10001"
                  min="1"
                  required
                />
              </div>

              {operation === "transfer" && (
                <div>
                  <label>Destination Account ID</label>

                  <input
                    type="number"
                    value={destinationAccountId}
                    onChange={(event) =>
                      setDestinationAccountId(event.target.value)
                    }
                    placeholder="Example: 10002"
                    min="1"
                    required
                  />
                </div>
              )}

              <div>
                <label>Amount</label>

                <input
                  type="number"
                  value={amount}
                  onChange={(event) => setAmount(event.target.value)}
                  placeholder="Enter amount"
                  min="1"
                  step="0.01"
                  required
                />
              </div>

              {operation !== "transfer" && (
                <div>
                  <label>Description</label>

                  <input
                    type="text"
                    value={description}
                    onChange={(event) => setDescription(event.target.value)}
                    placeholder="Example: Salary deposit"
                  />
                </div>
              )}
            </div>

            <button className="submit-button" type="submit">
              {operation === "deposit" && "Make Deposit"}
              {operation === "withdraw" && "Make Withdrawal"}
              {operation === "transfer" && "Transfer Money"}
            </button>
          </form>

          {message && (
            <div className="transaction-message success">
              {message}
            </div>
          )}

          {error && (
            <div className="transaction-message error">
              {error}
            </div>
          )}
        </div>

        <div className="panel">
          <h2>Transaction History</h2>

          <div className="transaction-filters">
            <input
              className="search-input"
              type="text"
              value={transactionSearch}
              onChange={(event) => setTransactionSearch(event.target.value)}
              placeholder="Search by account ID, transaction ID or description"
            />
            <select
              value={transactionTypeFilter}
              onChange={(event) => setTransactionTypeFilter(event.target.value)}
            >
              <option value="ALL">All Types</option>
              <option value="DEPOSIT">Deposit</option>
              <option value="WITHDRAWAL">Withdrawal</option>
              <option value="TRANSFER">Transfer</option>
            </select>
          </div>

          <div className="table-wrapper">
            <table>
              <thead>
                <tr>
                  <th>ID</th>
                  <th>Account ID</th>
                  <th>Type</th>
                  <th>Amount</th>
                  <th>Date</th>
                  <th>Description</th>
                </tr>
              </thead>

              <tbody>
                {filteredTransactions.map((transaction) => (
                    <tr key={transaction.transactionId}>
                      <td>{transaction.transactionId}</td>
                      <td>{transaction.accountId}</td>
                      <td>
                        <span className="badge">
                          {transaction.transactionType}
                        </span>
                      </td>
                      <td>{formatMoney(transaction.amount)}</td>
                      <td>{transaction.transactionDate}</td>
                      <td>{transaction.description}</td>
                    </tr>
                  ))}
                {filteredTransactions.length === 0 && (
                  <tr><td colSpan="6">No transactions found.</td></tr>
                )}
              </tbody>
            </table>
          </div>
        </div>
      </>
    );
  };

  const Loans = () => (
    <>
      <div className="page-title">
        <h1>Loans</h1>
        <p>Customer loan portfolio</p>
      </div>

      <div className="panel">
        <div className="table-wrapper">
          <table>
            <thead>
              <tr>
                <th>Loan ID</th>
                <th>Customer ID</th>
                <th>Loan Type</th>
                <th>Loan Amount</th>
                <th>Outstanding</th>
                <th>Interest Rate</th>
                <th>Status</th>
              </tr>
            </thead>

            <tbody>
              {loans.map((loan) => (
                <tr key={loan.loanId}>
                  <td>{loan.loanId}</td>
                  <td>{loan.customerId}</td>
                  <td>{loan.loanType}</td>
                  <td>{formatMoney(loan.loanAmount)}</td>
                  <td>{formatMoney(loan.outstandingAmount)}</td>
                  <td>{loan.interestRate}%</td>
                  <td>
                    <span className="badge">{loan.status}</span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </>
  );

  if (loading) {
    return <div className="loading">Loading Banking Dashboard...</div>;
  }

  return (
    <div className="app-layout">
      <aside className="sidebar">
        <div className="logo">
          <div className="logo-icon">B</div>

          <div>
            <strong>Banking</strong>
            <small>Analytics System</small>
          </div>
        </div>

        <nav>
          <button
            className={page === "dashboard" ? "active" : ""}
            onClick={() => setPage("dashboard")}
          >
            📊 Dashboard
          </button>

          <button
            className={page === "customers" ? "active" : ""}
            onClick={() => setPage("customers")}
          >
            👥 Customers
          </button>

          <button
            className={page === "accounts" ? "active" : ""}
            onClick={() => setPage("accounts")}
          >
            🏦 Accounts
          </button>

          <button
            className={page === "transactions" ? "active" : ""}
            onClick={() => setPage("transactions")}
          >
            💳 Transactions
          </button>

          <button
            className={page === "loans" ? "active" : ""}
            onClick={() => setPage("loans")}
          >
            💰 Loans
          </button>
        </nav>

        <div className="sidebar-bottom">
          <span>● System Online</span>
          <small>Spring Boot + MySQL</small>
        </div>
      </aside>

      <div className="main-content">
        <header className="topbar">
          <div>
            <strong>Banking Customer & Transaction Analysis</strong>
          </div>

          <div className="live-status">● Live</div>
        </header>

        <main>
          {page === "dashboard" && <Dashboard />}
          {page === "customers" && <Customers />}
          {page === "accounts" && <Accounts />}
          {page === "transactions" && <Transactions />}
          {page === "loans" && <Loans />}
        </main>
      </div>
    </div>
  );
}

export default App;