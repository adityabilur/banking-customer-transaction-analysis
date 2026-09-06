package banking_system.controller;

import java.math.BigDecimal;
import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import banking_system.entity.Transaction;
import banking_system.service.TransactionService;
import banking_system.service.TransferService;

@RestController
@RequestMapping("/api/transactions")
public class TransactionController {

    private final TransactionService transactionService;
    private final TransferService transferService;

    public TransactionController(
            TransactionService transactionService,
            TransferService transferService) {
        this.transactionService = transactionService;
        this.transferService = transferService;
    }

    @GetMapping
    public List<Transaction> getAllTransactions() {
        return transactionService.getAllTransactions();
    }

    @GetMapping("/{id}")
    public Transaction getTransactionById(@PathVariable Integer id) {
        return transactionService.getTransactionById(id);
    }

    @GetMapping("/account/{accountId}")
    public List<Transaction> getTransactionsByAccount(@PathVariable Integer accountId) {
        return transactionService.getTransactionsByAccount(accountId);
    }

    @PostMapping("/deposit")
    public Transaction deposit(
            @RequestParam Integer accountId,
            @RequestParam BigDecimal amount,
            @RequestParam(required = false) String description) {

        return transactionService.createDeposit(accountId, amount, description);
    }

    @PostMapping("/withdraw")
    public Transaction withdraw(
            @RequestParam Integer accountId,
            @RequestParam BigDecimal amount,
            @RequestParam(required = false) String description) {

        return transactionService.createWithdrawal(accountId, amount, description);
    }

    @PostMapping("/transfer")
    public String transfer(
            @RequestParam Integer sourceAccountId,
            @RequestParam Integer destinationAccountId,
            @RequestParam BigDecimal amount) {

        transferService.transfer(
                sourceAccountId,
                destinationAccountId,
                amount);

        return "Transfer successful";
    }
}