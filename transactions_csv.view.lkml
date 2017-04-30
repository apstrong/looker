view: transactions_csv {
  sql_table_name: mint_data.transactions_csv ;;

  dimension: account_name {
    type: string
    sql: ${TABLE}.Account_Name ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.Amount ;;
    value_format_name: usd
  }

  dimension: category_raw {
    hidden: yes
    type: string
    sql: ${TABLE}.Category ;;
  }

  dimension: category {
    type: string
    sql: CASE
          WHEN ${category_raw} IN ('Sports','Sporting Goods') THEN 'Sports'
          ELSE ${category_raw}
        END;;
  }

  dimension_group: date {
    type: time
    timeframes: [
      raw,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    sql: cast(${TABLE}.Date as timestamp) ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.Description ;;
  }

  dimension: labels {
    type: string
    sql: ${TABLE}.Labels ;;
  }

  dimension: notes {
    type: string
    sql: ${TABLE}.Notes ;;
  }

  dimension: original_description {
    type: string
    sql: ${TABLE}.Original_Description ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}.Transaction_Type ;;
  }

  measure: count {
    label: "Number of Transactions"
    type: count
    drill_fields: [account_name]
  }

  measure: total_amount {
    type: sum
    sql: ${amount} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: total_spent {
    type: sum
    sql: ${amount} ;;
    filters: {
      field: transaction_type
      value: "debit"
    }
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: average_spent {
    type: average
    sql: ${amount} ;;
    filters: {
      field: transaction_type
      value: "debit"
    }
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: total_earned {
    type: sum
    sql: ${amount} ;;
    filters: {
      field: transaction_type
      value: "credit"
    }
    value_format_name: usd
    drill_fields: [detail*]
  }

  measure: cash_flow {
    type: number
    sql: ${total_earned} - ${total_spent} ;;
    value_format_name: usd
    drill_fields: [total_earned, total_spent]
  }


set: detail {
  fields: [description, original_description, category, account_name, amount]
}


}
