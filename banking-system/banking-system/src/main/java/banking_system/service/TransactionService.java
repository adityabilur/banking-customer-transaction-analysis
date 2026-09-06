package banking_system.service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;

import banking_system.entity.Transaction;
import banking_system.repository.TransactionRepository;

@Service
public class TransactionService {

    private final TransactionRepository transactionRepository;

    public TransactionService(TransactionRepository transactionRepository) {
        this.transactionRepository = transactionRepository;
    }

    public List<Transaction> getAllTransactions() {
        return transactionRepository.findAll();
    }

    public Transaction getTransactionById(Integer id) {
        return transactionRepository.findById(id).orElse(null);
    }

    public List<Transaction> getTransactionsByAccount(Integer accountId) {
        return transactionRepository.findByAccountId(accountId);
    }

    public Transaction createDeposit(
            Integer accountId,
            BigDecimal amount,
            String description) {

        Transaction transaction = new Transaction();

        Transaction lastTransaction =
                transactionRepository.findTopByOrderByTransactionIdDesc();

        Integer nextId = lastTransaction.getTransactionId() + 1;

        transaction.setTransactionId(nextId);
        transaction.setAccountId(accountId);
        transaction.setTransactionType("DEPOSIT");
        transaction.setAmount(amount);
        transaction.setTransactionDate(LocalDateTime.now());
        transaction.setDescription(description);

        return transactionRepository.save(transaction);
    }

    public Transaction createWithdrawal(
            Integer accountId,
            BigDecimal amount,
            String description) {

        Transaction transaction = new Transaction();

        Transaction lastTransaction =
                transactionRepository.findTopByOrderByTransactionIdDesc();

        Integer nextId = lastTransaction.getTransactionId() + 1;

        transaction.setTransactionId(nextId);
        transaction.setAccountId(accountId);
        transaction.setTransactionType("WITHDRAWAL");
        transaction.setAmount(amount);
        transaction.setTransactionDate(LocalDateTime.now());
        transaction.setDescription(description);

        return transactionRepository.save(transaction);
    }
}