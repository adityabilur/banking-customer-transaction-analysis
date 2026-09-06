package banking_system.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import banking_system.entity.Transaction;

public interface TransactionRepository extends JpaRepository<Transaction, Integer> {

    List<Transaction> findByAccountId(Integer accountId);

    Transaction findTopByOrderByTransactionIdDesc();
}