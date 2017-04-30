connection: "bigquery"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: transactions_csv {
  label: "Mint Transactions"
  view_label: "Transactions"
  sql_always_where: ${category} NOT IN  ('Transfer','Credit Card Payment') ;;
}
