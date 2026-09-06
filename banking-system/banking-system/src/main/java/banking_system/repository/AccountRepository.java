package banking_system.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import banking_system.entity.Account;

public interface AccountRepository extends JpaRepository<Account, Integer> {

    List<Account> findByCustomerId(Integer customerId);
}