{{ config (
    tags=['dunesql']
    , alias = alias('etv_keeper_work')
    , post_hook = '{{ expose_spells(\'["ethereum", "optimism", "polygon"]\',
                                "project", 
                                "keep3r",
                                 \'["0xr3x"]\') }}'
) }}


    SELECT
      contract_address,
      evt_tx_hash,
      evt_index,
      evt_block_time,
      evt_block_number,
      cast(_credit as varbinary) as _credit,
      _gasLeft,
      _job,
      _keeper,
      _amount as _payment,
      'ethereum' as blockchain
    FROM
      {{ source(
        'keep3r_network_ethereum',
        'Keep3r_evt_KeeperWork'
      ) }}
    UNION
    SELECT
      *,
      'ethereum' as blockchain
    FROM
      {{ source(
        'keep3r_network_ethereum',
        'Keep3r_v2_evt_KeeperWork'
      ) }}
      UNION
    SELECT
      *,
      'optimism' as blockchain
    FROM
      {{ source(
        'keep3r_network_optimism',
        'Keep3rSidechain_evt_KeeperWork'
      ) }}
      UNION
    SELECT
      *,
      'polygon' as blockchain
    FROM
      {{ source(
        'keep3r_network_polygon',
        'Keep3rSidechain_evt_KeeperWork'
      ) }}