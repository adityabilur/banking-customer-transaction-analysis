package banking_system.analytics;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/analytics")
@CrossOrigin(origins = "http://localhost:5173")
public class AnalyticsController {

    private final AnalyticsRepository analyticsRepository;

    public AnalyticsController(AnalyticsRepository analyticsRepository) {
        this.analyticsRepository = analyticsRepository;
    }

    @GetMapping("/top-customers")
    public List<Object[]> getTopCustomers() {
        return analyticsRepository.getTopCustomers();
    }

    @GetMapping("/monthly-transactions")
    public List<Object[]> getMonthlyTransactions() {
        return analyticsRepository.getMonthlyTransactions();
    }

    @GetMapping("/branch-performance")
    public List<Object[]> getBranchPerformance() {
        return analyticsRepository.getBranchPerformance();
    }

    @GetMapping("/summary")
    public Map<String, Object> getSummary() {

        Object[] result = analyticsRepository.getSummary();

        Map<String, Object> summary = new LinkedHashMap<>();

        summary.put("totalCustomers", result[0]);
        summary.put("totalAccounts", result[1]);
        summary.put("totalBalance", result[2]);
        summary.put("totalTransactions", result[3]);
        summary.put("totalTransactionAmount", result[4]);
        summary.put("totalLoans", result[5]);
        summary.put("totalOutstandingLoans", result[6]);

        return summary;
    }

    @GetMapping("/transaction-types")
    public List<Object[]> getTransactionTypes() {
        return analyticsRepository.getTransactionTypes();
    }

    @GetMapping("/loan-exposure")
    public List<Object[]> getLoanExposure() {
        return analyticsRepository.getLoanExposure();
    }

    @GetMapping("/customer-financial-summary")
    public List<Object[]> getCustomerFinancialSummary() {
        return analyticsRepository.getCustomerFinancialSummary();
    }
}