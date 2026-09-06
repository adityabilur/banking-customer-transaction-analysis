package banking_system.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import banking_system.entity.Customer;

public interface CustomerRepository extends JpaRepository<Customer, Integer> {
}