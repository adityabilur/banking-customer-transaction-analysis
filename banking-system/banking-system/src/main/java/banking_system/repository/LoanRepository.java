package banking_system.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import banking_system.entity.Loan;

public interface LoanRepository extends JpaRepository<Loan, Integer> {

    List<Loan> findByCustomerId(Integer customerId);
}