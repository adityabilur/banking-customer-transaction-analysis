package banking_system.service;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import banking_system.entity.Account;
import banking_system.entity.Transaction;
import banking_system.repository.AccountRepository;
import banking_system.repository.TransactionRepository;

@Service
public class TransferService {

    private final AccountRepository accountRepository;
    private final TransactionRepository transactionRepository;

    public TransferService(
            AccountRepository accountRepository,
            TransactionRepository transactionRepository) {
        this.accountRepository = accountRepository;
        this.transactionRepository = transactionRepository;
    }

    @Transactional
    public void transfer(
            Integer sourceAccountId,
            Integer destinationAccountId,
            BigDecimal amount) {

        Account sourceAccount = accountRepository
                .findById(sourceAccountId)
                .orElseThrow();

        Account destinationAccount = accountRepository
                .findById(destinationAccountId)
                .orElseThrow();

        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new RuntimeException("Amount must be greater than zero");
        }

        if (sourceAccount.getBalance().compareTo(amount) < 0) {
            throw new RuntimeException("Insufficient balance");
        }

        sourceAccount.setBalance(
                sourceAccount.getBalance().subtract(amount));

        destinationAccount.setBalance(
                destinationAccount.getBalance().add(amount));

        accountRepository.save(sourceAccount);
        accountRepository.save(destinationAccount);

        Integer lastId = transactionRepository
                .findTopByOrderByTransactionIdDesc()
                .getTransactionId();

        Transaction withdrawal = new Transaction();
        withdrawal.setTransactionId(lastId + 1);
        withdrawal.setAccountId(sourceAccountId);
        withdrawal.setTransactionType("TRANSFER");
        withdrawal.setAmount(amount);
        withdrawal.setTransactionDate(LocalDateTime.now());
        withdrawal.setDescription("Transfer to account " + destinationAccountId);

        Transaction deposit = new Transaction();
        deposit.setTransactionId(lastId + 2);
        deposit.setAccountId(destinationAccountId);
        deposit.setTransactionType("TRANSFER");
        deposit.setAmount(amount);
        deposit.setTransactionDate(LocalDateTime.now());
        deposit.setDescription("Transfer from account " + sourceAccountId);

        transactionRepository.save(withdrawal);
        transactionRepository.save(deposit);
    }
}