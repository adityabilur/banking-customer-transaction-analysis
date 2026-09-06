package banking_system.analytics;

import java.util.List;

import org.springframework.stereotype.Repository;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

@Repository
public class AnalyticsRepository {

    @PersistenceContext
    private EntityManager entityManager;

    public List<Object[]> getTopCustomers() {
        String sql = """
                SELECT
                    c.customer_id,
                    CONCAT(c.first_name, ' ', c.last_name),
                    SUM(a.balance)
                FROM customers c
                JOIN accounts a ON c.customer_id = a.customer_id
                GROUP BY c.customer_id, c.first_name, c.last_name
                ORDER BY SUM(a.balance) DESC
                LIMIT 10
                """;

        return entityManager.createNativeQuery(sql).getResultList();
    }

    public List<Object[]> getMonthlyTransactions() {
        String sql = """
                SELECT
                    DATE_FORMAT(transaction_date, '%Y-%m'),
                    COUNT(*),
                    SUM(amount)
                FROM transactions
                GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
                ORDER BY DATE_FORMAT(transaction_date, '%Y-%m')
                """;

        return entityManager.createNativeQuery(sql).getResultList();
    }

    public List<Object[]> getBranchPerformance() {
        String sql = """
                SELECT
                    b.branch_id,
                    b.branch_name,
                    COALESCE(a.total_accounts, 0),
                    COALESCE(a.total_balance, 0),
                    COALESCE(t.total_transactions, 0),
                    COALESCE(t.transaction_amount, 0)
                FROM branches b
                LEFT JOIN (
                    SELECT
                        branch_id,
                        COUNT(*) AS total_accounts,
                        SUM(balance) AS total_balance
                    FROM accounts
                    GROUP BY branch_id
                ) a ON b.branch_id = a.branch_id
                LEFT JOIN (
                    SELECT
                        acc.branch_id,
                        COUNT(tr.transaction_id) AS total_transactions,
                        COALESCE(SUM(tr.amount), 0) AS transaction_amount
                    FROM accounts acc
                    JOIN transactions tr
                        ON acc.account_id = tr.account_id
                    GROUP BY acc.branch_id
                ) t ON b.branch_id = t.branch_id
                ORDER BY COALESCE(t.transaction_amount, 0) DESC
                """;

        return entityManager.createNativeQuery(sql).getResultList();
    }

    public Object[] getSummary() {
        String sql = """
                SELECT
                    (SELECT COUNT(*) FROM customers),
                    (SELECT COUNT(*) FROM accounts),
                    (SELECT COALESCE(SUM(balance), 0) FROM accounts),
                    (SELECT COUNT(*) FROM transactions),
                    (SELECT COALESCE(SUM(amount), 0) FROM transactions),
                    (SELECT COUNT(*) FROM loans),
                    (SELECT COALESCE(SUM(outstanding_amount), 0) FROM loans)
                """;

        return (Object[]) entityManager.createNativeQuery(sql).getSingleResult();
    }

    public List<Object[]> getTransactionTypes() {
        String sql = """
                SELECT
                    transaction_type,
                    COUNT(*),
                    SUM(amount)
                FROM transactions
                GROUP BY transaction_type
                ORDER BY SUM(amount) DESC
                """;

        return entityManager.createNativeQuery(sql).getResultList();
    }

    public List<Object[]> getLoanExposure() {
        String sql = """
                SELECT
                    loan_type,
                    COUNT(*),
                    SUM(loan_amount),
                    SUM(outstanding_amount)
                FROM loans
                GROUP BY loan_type
                ORDER BY SUM(outstanding_amount) DESC
                """;

        return entityManager.createNativeQuery(sql).getResultList();
    }

    public List<Object[]> getCustomerFinancialSummary() {
        String sql = """
                SELECT
                    c.customer_id,
                    CONCAT(c.first_name, ' ', c.last_name),
                    COALESCE(a.total_balance, 0),
                    COALESCE(a.total_accounts, 0),
                    COALESCE(t.total_transactions, 0),
                    COALESCE(l.total_outstanding, 0)
                FROM customers c
                LEFT JOIN (
                    SELECT
                        customer_id,
                        SUM(balance) AS total_balance,
                        COUNT(*) AS total_accounts
                    FROM accounts
                    GROUP BY customer_id
                ) a ON c.customer_id = a.customer_id
                LEFT JOIN (
                    SELECT
                        acc.customer_id,
                        COUNT(tr.transaction_id) AS total_transactions
                    FROM accounts acc
                    JOIN transactions tr
                        ON acc.account_id = tr.account_id
                    GROUP BY acc.customer_id
                ) t ON c.customer_id = t.customer_id
                LEFT JOIN (
                    SELECT
                        customer_id,
                        SUM(outstanding_amount) AS total_outstanding
                    FROM loans
                    GROUP BY customer_id
                ) l ON c.customer_id = l.customer_id
                ORDER BY COALESCE(a.total_balance, 0) DESC
                """;

        return entityManager.createNativeQuery(sql).getResultList();
    }
}