\# Banking Customer \& Transaction Analysis System



A full-stack banking management and analytics system built using MySQL, Spring Boot, and React.



\## Overview



This project manages banking customers, accounts, transactions, branches, account types, and loans. It also provides analytical insights into customer activity, transaction trends, branch performance, and loan exposure.



\## Tech Stack



\- MySQL

\- Spring Boot

\- Spring Data JPA

\- REST APIs

\- React.js

\- Axios

\- Recharts

\- Maven



\## Key Features



\### Customer Management

\- View customers

\- View customer details

\- View customer accounts and loans

\- Analyze customer transaction activity



\### Account \& Transaction Management

\- View accounts

\- Deposit money

\- Withdraw money

\- Transfer money between accounts

\- View transaction history



\### Banking Analytics

\- Overall banking summary

\- Top customers by activity

\- Monthly transaction analysis

\- Branch performance

\- Transaction type distribution

\- Loan exposure

\- Customer financial summary

\- Low-balance and high-activity insights



\## Database Design



The MySQL database contains six main tables:



\- Customers

\- Branches

\- Account Types

\- Accounts

\- Transactions

\- Loans



\### Relationships



```text

Customer

&#x20;  |

&#x20;  +---- Account

&#x20;           |

&#x20;           +---- Transaction

&#x20;           |

&#x20;           +---- Branch

&#x20;           |

&#x20;           +---- Account Type



Customer

&#x20;  |

&#x20;  +---- Loan

