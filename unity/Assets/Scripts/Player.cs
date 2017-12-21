using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Player : MonoBehaviour {

    public PlayerBullet bulletPrefab;
    public Transform bulletParent;
    public float fireTimeout = 0.2f;

    private Transform transformOrig;
    private bool fireReady = true;

	private void Start () {
        transformOrig = transform;
	}

    public void reset() {
        transform.position = transformOrig.position;
        transform.rotation = transformOrig.rotation;
        transform.localScale = transformOrig.localScale;
    }

    public void fire() {
        if (fireReady) {
            PlayerBullet b = GameObject.Instantiate(bulletPrefab, bulletParent).GetComponent<PlayerBullet>();
            b.transform.rotation = transform.rotation;
            b.transform.position = transform.position;
            fireReady = false;
            StartCoroutine(fireDelay());
        }
    }

    private IEnumerator fireDelay() {
        yield return new WaitForSeconds(fireTimeout);
        fireReady = true;
    }

}
